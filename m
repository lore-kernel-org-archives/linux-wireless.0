Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:50022 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753239AbdKXL3Y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Nov 2017 06:29:24 -0500
From: Pkshih <pkshih@realtek.com>
To: "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [RFC] rtlwifi: Add two components (kernel modules) to rtlwifi
Date: Fri, 24 Nov 2017 11:29:10 +0000
Message-ID: <5B2DA6FDDF928F4E855344EE0A5C39D105846AAB@RTITMBSV07.realtek.com.tw> (sfid-20171124_122928_301704_3C957DAA)
Content-Type: text/plain; charset="Windows-1252"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Johannes and Kalle,
 
In order to reduce effort to maintain the MAC/BB/RF functions and keep them
to be up-to-date, we introduce two new components that are phydm and halmac
maintained by Realtek's MAC/BB/RF teams. The components are similar to
existing component btcoexist that used by various platforms and OSs, but
they're quite bigger than btcoexist.
 
The phydm is short for 'PHY dynamic mechanism' that used to adapt to
different environments to yield good performance, and also provide basic
APIs to control BB and RF. The halmac is short for 'HAL MAC' that provides
APIs to control wifi MAC and power sequence.
 
Using these components, the core part of rtlwifi can access wifi chip
through readable APIs instead of registers, so it will be easier to
understand.
 
The followings will show architecture and our questions that need
your comments:
 
1. Architecture -- ops, dispatching routine
 
   Similar to the component btcoexist, phydm and halmac provide many ops
   that looks like:
   
    struct rtl_halmac_ops {
        int (*halmac_init_adapter)(struct rtl_priv *);
        int (*halmac_deinit_adapter)(struct rtl_priv *);
        int (*halmac_init_hal)(struct rtl_priv *);
        int (*halmac_deinit_hal)(struct rtl_priv *);
        int (*halmac_poweron)(struct rtl_priv *);
        int (*halmac_poweroff)(struct rtl_priv *);
   
        ...
    }
   
    struct rtl_phydm_ops {
        /* init/deinit priv */
        int (*phydm_init_priv)(struct rtl_priv *rtlpriv, struct rtl_phydm_params *params);
        int (*phydm_deinit_priv)(struct rtl_priv *rtlpriv);
        bool (*phydm_load_txpower_by_rate)(struct rtl_priv *rtlpriv);
        bool (*phydm_load_txpower_limit)(struct rtl_priv *rtlpriv);
       
        ...
    }
 
 
   Thus, the rtlwifi's core part can access the components by these ops,
   and then the ops will dispatch to proper routines according to specified
   chip. The dispatching code looks like:
 
    if (dm->support_ic_type == ODM_RTL8723D) {
        if (config_type == CONFIG_BB_PHY_REG)
            READ_AND_CONFIG_MP(8723d, _phy_reg);
        else if (config_type == CONFIG_BB_AGC_TAB)
            READ_AND_CONFIG_MP(8723d, _agc_tab);
        else if (config_type == CONFIG_BB_PHY_REG_PG)
            READ_AND_CONFIG_MP(8723d, _phy_reg_pg);
    }
 
    if (dm->support_ic_type == ODM_RTL8822B) {
        if (config_type == CONFIG_BB_PHY_REG)
            READ_AND_CONFIG_MP(8822b, _phy_reg);
        else if (config_type == CONFIG_BB_AGC_TAB)
            READ_AND_CONFIG_MP(8822b, _agc_tab);
        else if (config_type == CONFIG_BB_PHY_REG_PG) {
            if (dm->rfe_type == 2)
                READ_AND_CONFIG_MP(8822b, _phy_reg_pg_type2);
            else if (dm->rfe_type == 3)
                READ_AND_CONFIG_MP(8822b, _phy_reg_pg_type3);
            else if (dm->rfe_type == 4)
                READ_AND_CONFIG_MP(8822b, _phy_reg_pg_type4);
            else if (dm->rfe_type == 5)
                READ_AND_CONFIG_MP(8822b, _phy_reg_pg_type5);
            else if (dm->rfe_type == 12)
                READ_AND_CONFIG_MP(8822b, _phy_reg_pg_type12);
            else if (dm->rfe_type == 15)
                READ_AND_CONFIG_MP(8822b, _phy_reg_pg_type15);
            else if (dm->rfe_type == 16)
                READ_AND_CONFIG_MP(8822b, _phy_reg_pg_type16);
            else if (dm->rfe_type == 17)
                READ_AND_CONFIG_MP(8822b, _phy_reg_pg_type17);
            else
                READ_AND_CONFIG_MP(8822b, _phy_reg_pg);
        }
    }
 
 
2. Debug message
 
   Because the components contain many sub-components, the debug messages
   should be limited. We add PHYDM_DBG() and HALMAC_RT_TRACE() with
   parameter 'comp' to output messages of the specified sub-components.
   Then, these two macros will redirect message to RT_TRACE()
   with corresponding debug components that are COMP_PHYDM and COMP_HALMAC.
   Though the parameter 'comp' in macro HALMAC_RT_TRACE() isn't used,
   it was preserved to filter messages in the future.
   The macros look like:
 
    #define PHYDM_DBG(dm, comp, fmt, args...)               \
        do {                                \
            if ((comp) & (dm->debug_components)) {      \
                RT_TRACE(((struct rtl_priv *)dm->adapter),  \
                    COMP_PHYDM, DBG_DMESG, "[PHYDM] " fmt, \
                    ## args);              \
           }                                               \
       } while (0)
   
   
    #define HALMAC_RT_TRACE(drv_adapter, comp, level, fmt, args...)   \
        RT_TRACE(drv_adapter, COMP_HALMAC, level, fmt, ## args)
   
   
    #define RT_TRACE(rtlpriv, comp, level, fmt, ...)            \
 
 
3. Debug FS
 
   Considering the debug of ethtool, it can dump registers and efuse
   content, but we also need to check status and change state for
   remote debug. For example, we need to check btcoexist's status
   continuously to know whether the decision is correct or not. If
   something is incorrect, we can write a command to switch to manual
   mode. In this mode, we'll try some decision rules manually to clarify
   the issue, and then we add the solution to driver. For the reasons,
   debugfs is needed.
 
   Normally, rtlwifi's debugfs locates on /sys/kernel/debug/rtlwifi/11-22-33-44-55-66/,
   and there're many entries within this directory. For example,
   mac_xx, bb_xx and rf_xx are used to dump registers, and write_yy
   are used to write register and issue firmware commands. For the
   various purposes, the fs modes of these entries will be read/read-write/write.
   The debug code is enclosed by the compiler flag CONFIG_RTLWIFI_DEBUG,
   so one can turn on/off by this flag existed in Kconfig.
 
 
4. Directory structure
 
   The component phydm contains BB and RF functions, and RF part is located
   on 'rtlwifi/phydm/halrf/'. Each chip is put into individual directory, and
   directories look like:
 
   rtlwifi/phydm/rtl8822b/
   rtlwifi/phydm/rtl8723d/
   rtlwifi/phydm/halrf/rtl8822b/
   rtlwifi/phydm/halrf/rtl8723d/
 
 
   Similarly, directory structure of the component halmac looks like:
 
   rtlwifi/halmac/halmac_88xx
   rtlwifi/halmac/halmac_88xx/halmac_8822b
   rtlwifi/halmac/halmac_88xx/halmac_8821c
 
 
5. Defects
 
   We found some defects in rtlwifi or new components, and need your comments.
 
5.1. The enumerator layout is totally different with old ICs
 
    Take rate index for example, the older ICs didn't support VHT, hence
    the original code did not consider to integrate VHT related flag/enum
    info. Like:
 
    enum ratr_table_mode {
        RATR_INX_WIRELESS_NGB = 0,
        RATR_INX_WIRELESS_NG = 1,
        RATR_INX_WIRELESS_NB = 2,
        RATR_INX_WIRELESS_N = 3,
        RATR_INX_WIRELESS_GB = 4,
        RATR_INX_WIRELESS_G = 5,
        RATR_INX_WIRELESS_B = 6,
        RATR_INX_WIRELESS_MC = 7,
        RATR_INX_WIRELESS_A = 8,
        RATR_INX_WIRELESS_AC_5N = 8,
        RATR_INX_WIRELESS_AC_24N = 9,
    };
   
    enum ratr_table_mode_new {
        RATEID_IDX_BGN_40M_2SS = 0,
        RATEID_IDX_BGN_40M_1SS = 1,
        RATEID_IDX_BGN_20M_2SS_BN = 2,
        RATEID_IDX_BGN_20M_1SS_BN = 3,
        RATEID_IDX_GN_N2SS = 4,
        RATEID_IDX_GN_N1SS = 5,
        RATEID_IDX_BG = 6,
        RATEID_IDX_G = 7,
        RATEID_IDX_B = 8,
        RATEID_IDX_VHT_2SS = 9,
        RATEID_IDX_VHT_1SS = 10,
        RATEID_IDX_MIX1 = 11,
        RATEID_IDX_MIX2 = 12,
        RATEID_IDX_VHT_3SS = 13,
        RATEID_IDX_BGN_3SS = 14,
    };
 
    ,which leads to the result that the driver needs to have a function
    "rtl_mrate_idx_to_arfr_id" to convert the rate index between old and
    new series of ICs. These values are associated with hardware design, so it
    is the only way for it.
 
5.2. Usage of delay
 
    The phydm uses a lot of “mdelay/udelay” functions to accomplish the
    hardware settings.
 
5.3. The code flow of the phydm module is not "structuralized"
 
    A lot of deep indents to nest the decision statements. Like:
 
 
    If () {
        If () {
            for () {
                for () {
                    if () {
                    }
                }
            }
        } else {
            switch () {
            case:
                if ()
                break;
            }
        }
    }
 
    And the code just written straightly to set registers to do everything.
    So the code may has such codes to control hardware registers.
 
    For example:
 
    if ((*p_dm->p_channel <= 14) && (*p_dm->p_band_width == CHANNEL_WIDTH_20)) {
        if (p_dm->rssi_min >= rssi_l2h) {
        /*if (p_dm->bhtstfdisabled == false)*/
        odm_set_bb_reg(p_dm, 0x8d8, BIT(17), 0x1);
       
        odm_set_bb_reg(p_dm, 0x98c, 0x7fc0000, 0x0);
        odm_set_bb_reg(p_dm, 0x818, 0x7000000, 0x1);
        odm_set_bb_reg(p_dm, 0xc04, BIT(18), 0x0);
        odm_set_bb_reg(p_dm, 0xe04, BIT(18), 0x0);
        if (p_dm->p_advance_ota & PHYDM_HP_OTA_SETTING_A) {
            odm_set_bb_reg(p_dm, 0x19d8, MASKDWORD, 0x444);
            odm_set_bb_reg(p_dm, 0x19d4, MASKDWORD, 0x4444aaaa);
        } else if (p_dm->p_advance_ota & PHYDM_HP_OTA_SETTING_B) {
            odm_set_bb_reg(p_dm, 0x19d8, MASKDWORD, 0x444);
            odm_set_bb_reg(p_dm, 0x19d4, MASKDWORD, 0x444444aa);
        }
        } else if (p_dm->rssi_min < rssi_h2l) {
            /*if (p_dm->bhtstfdisabled == true)*/
            odm_set_bb_reg(p_dm, 0x8d8, BIT(17), 0x0);
           
            odm_set_bb_reg(p_dm, 0x98c, MASKDWORD, 0x43440000);
            odm_set_bb_reg(p_dm, 0x818, 0x7000000, 0x4);
            odm_set_bb_reg(p_dm, 0xc04, (BIT(18) | BIT(21)), 0x0);
            odm_set_bb_reg(p_dm, 0xe04, (BIT(18) | BIT(21)), 0x0);
            odm_set_bb_reg(p_dm, 0x19d8, MASKDWORD, 0xaaa);
            odm_set_bb_reg(p_dm, 0x19d4, MASKDWORD, 0xaaaaaaaa);
        }
    } else {
        /*odm_set_bb_reg(p_dm, 0x8d8, BIT(17), 0x0);*/
        odm_set_bb_reg(p_dm, 0x98c, MASKDWORD, 0x43440000);
        odm_set_bb_reg(p_dm, 0x818, 0x7000000, 0x4);
        odm_set_bb_reg(p_dm, 0xc04, (BIT(18) | BIT(21)), 0x0);
        odm_set_bb_reg(p_dm, 0xe04, (BIT(18) | BIT(21)), 0x0);
        odm_set_bb_reg(p_dm, 0x19d8, MASKDWORD, 0xaaa);
        odm_set_bb_reg(p_dm, 0x19d4, MASKDWORD, 0xaaaaaaaa);
    }
 
    These hardware operations may not easy to read without documents.
 
5.4. Pass the context data as (void *)
 
    For convenience, the struct mainly used by phydm is passed the type
    (void *). Like:
 
    static void phydm_acs_nhm_setting(void *p_dm_void, u32 acs_step)
 
 
 
Because the codes are quite big, I don't attach them. If you need full
source code to reference, you can find it in drivers/staging/rtlwifi/ that
is little old, or I can send it as private mail to you.
 
Thanks
PK
 
