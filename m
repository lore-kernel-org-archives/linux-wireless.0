Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:29482 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756270Ab1KNUok (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Nov 2011 15:44:40 -0500
Subject: Re: iwlagn 3.0.9 aggreggation messages
From: wwguy <wey-yi.w.guy@intel.com>
To: Lars Schotte <gusto@guttok.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20111114201947.58d5fdf6@hana.gusto>
References: <20111114131642.31e8ddbd@hana.gusto>
	 <1321283410.13578.33.camel@wwguy-ubuntu>
	 <20111114201947.58d5fdf6@hana.gusto>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Nov 2011 12:38:21 -0800
Message-ID: <1321303101.1796.8.camel@wwguy-ubuntu> (sfid-20111114_214451_734524_3D6EA010)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Schotte,

looks like driver has problem activate the aggregation, you can see in
the log, the aggregation queue being activate then deactivate soon
after. that is why you are seeing the messages showing up in dmesg log.

what AP you are using? is similar thing happen if you connect to
different AP?

Thanks
Wey

On Mon, 2011-11-14 at 11:19 -0800, Lars Schotte wrote:
> so i have some output here:
> 
> 07766] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1790.407774] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1790.562150] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1790.562165] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1790.608484] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1790.608499] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1790.706065] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04B6, 12 bytes at 182[22]:4
> [ 1790.706112] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1791.706044] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04B7, 12 bytes at 183[23]:4
> [ 1791.706089] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1792.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04B8, 12 bytes at 184[24]:4
> [ 1792.706098] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1792.885031] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1792.885047] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1793.706050] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04B9, 12 bytes at 185[25]:4
> [ 1793.706103] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1793.977631] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1793.977646] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1793.979948] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x04BA, 92 bytes at 186[26]:4
> [ 1793.980032] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 1794.331713] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1794.331728] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1795.280295] ieee80211 phy0: I iwl_tt_handler Queueing thermal throttling work.
> [ 1795.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04BB, 12 bytes at 187[27]:4
> [ 1795.706085] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1796.513861] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1796.513878] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1796.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04BC, 12 bytes at 188[28]:4
> [ 1796.706099] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1796.804636] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1796.804652] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1798.706045] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04BD, 12 bytes at 189[29]:4
> [ 1798.706093] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1799.233093] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1799.233111] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1799.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04BE, 12 bytes at 190[30]:4
> [ 1799.706090] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1800.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04BF, 12 bytes at 191[31]:4
> [ 1800.706094] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1801.316646] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1801.316662] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1801.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04C0, 12 bytes at 192[0]:4
> [ 1801.706095] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1802.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04C1, 12 bytes at 193[1]:4
> [ 1802.706092] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1803.706037] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04C2, 12 bytes at 194[2]:4
> [ 1803.706082] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1804.573734] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1804.573750] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1804.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04C3, 12 bytes at 195[3]:4
> [ 1804.706093] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1805.706052] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04C4, 12 bytes at 196[4]:4
> [ 1805.706101] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1806.706039] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04C5, 12 bytes at 197[5]:4
> [ 1806.706090] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1807.706044] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04C6, 12 bytes at 198[6]:4
> [ 1807.706094] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1808.706037] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04C7, 12 bytes at 199[7]:4
> [ 1808.706083] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1809.696088] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
> [ 1809.696100] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
> [ 1809.696107] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
> [ 1809.696118] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x04C8, 96 bytes at 200[8]:4
> [ 1809.696184] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
> [ 1809.696209] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
> [ 1809.696216] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
> [ 1809.696223] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
> [ 1809.696232] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
> [ 1809.696239] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
> [ 1809.696297] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1809.696308] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1809.706033] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04C9, 12 bytes at 201[9]:4
> [ 1809.706076] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1810.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04CA, 12 bytes at 202[10]:4
> [ 1810.706097] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1811.706046] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04CB, 12 bytes at 203[11]:4
> [ 1811.706099] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1812.706044] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04CC, 12 bytes at 204[12]:4
> [ 1812.706088] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1813.706049] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04CD, 12 bytes at 205[13]:4
> [ 1813.706100] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1814.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04CE, 12 bytes at 206[14]:4
> [ 1814.706094] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1814.972097] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1814.972114] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1814.973473] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x04CF, 92 bytes at 207[15]:4
> [ 1814.973534] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 1815.862528] ieee80211 phy0: I iwl_tt_handler Queueing thermal throttling work.
> [ 1816.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04D0, 12 bytes at 208[16]:4
> [ 1816.706549] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1817.081600] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1817.081615] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1817.081686] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
> [ 1817.081696] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
> [ 1817.081703] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
> [ 1817.081714] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x04D1, 96 bytes at 209[17]:4
> [ 1817.081761] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
> [ 1817.081791] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
> [ 1817.081797] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
> [ 1817.081805] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
> [ 1817.081813] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
> [ 1817.081821] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
> [ 1817.081837] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1817.081846] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1817.084200] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x04D2, 92 bytes at 210[18]:4
> [ 1817.084261] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 1817.706046] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04D3, 12 bytes at 211[19]:4
> [ 1817.706087] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1818.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04D4, 12 bytes at 212[20]:4
> [ 1818.706090] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1819.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04D5, 12 bytes at 213[21]:4
> [ 1819.706097] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1819.920097] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1819.920117] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1820.424693] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1820.424711] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1820.424794] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1820.424803] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1820.433155] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1820.433170] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1820.433234] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1820.433242] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1820.433280] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1820.433288] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1820.580393] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1820.580407] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1820.597865] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1820.597878] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1820.600181] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x04D6, 92 bytes at 214[22]:4
> [ 1820.600244] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 1820.706038] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04D7, 12 bytes at 215[23]:4
> [ 1820.706085] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1822.075456] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1822.075471] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1822.077778] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x04D8, 92 bytes at 216[24]:4
> [ 1822.077840] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 1822.084859] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1822.084869] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1823.706039] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04D9, 12 bytes at 217[25]:4
> [ 1823.706090] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1824.706039] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04DA, 12 bytes at 218[26]:4
> [ 1824.706090] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1825.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04DB, 12 bytes at 219[27]:4
> [ 1825.706090] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1826.706044] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04DC, 12 bytes at 220[28]:4
> [ 1826.706100] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1827.216092] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
> [ 1827.216104] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
> [ 1827.216111] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
> [ 1827.216121] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x04DD, 96 bytes at 221[29]:4
> [ 1827.216188] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
> [ 1827.216221] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
> [ 1827.216229] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
> [ 1827.216236] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
> [ 1827.216245] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
> [ 1827.216253] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
> [ 1827.216277] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1827.216289] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1827.706049] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04DE, 12 bytes at 222[30]:4
> [ 1827.706098] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1828.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04DF, 12 bytes at 223[31]:4
> [ 1828.706094] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1829.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04E0, 12 bytes at 224[0]:4
> [ 1829.706091] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1830.706048] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04E1, 12 bytes at 225[1]:4
> [ 1830.706098] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1831.706044] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04E2, 12 bytes at 226[2]:4
> [ 1831.706094] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1832.633195] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1832.633213] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1832.633283] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
> [ 1832.633294] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
> [ 1832.633301] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
> [ 1832.633312] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x04E3, 96 bytes at 227[3]:4
> [ 1832.633392] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
> [ 1832.633869] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
> [ 1832.633877] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
> [ 1832.633884] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
> [ 1832.633893] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
> [ 1832.633900] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
> [ 1832.633917] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1832.633926] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1832.706039] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04E4, 12 bytes at 228[4]:4
> [ 1832.706089] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1833.669548] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1833.669565] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1833.773629] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1833.773647] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1833.854073] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1833.854088] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1835.490973] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1835.490988] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1836.706039] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04E5, 12 bytes at 229[5]:4
> [ 1836.706094] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1837.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04E6, 12 bytes at 230[6]:4
> [ 1837.706087] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1838.706049] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04E7, 12 bytes at 231[7]:4
> [ 1838.706093] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1839.169846] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1839.169861] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1839.706039] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04E8, 12 bytes at 232[8]:4
> [ 1839.706091] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1840.466716] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1840.466732] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1840.469073] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x04E9, 92 bytes at 233[9]:4
> [ 1840.469135] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 1841.706047] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04EA, 12 bytes at 234[10]:4
> [ 1841.706092] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1842.706048] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04EB, 12 bytes at 235[11]:4
> [ 1842.706092] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1843.706039] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04EC, 12 bytes at 236[12]:4
> [ 1843.706089] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1844.706046] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04ED, 12 bytes at 237[13]:4
> [ 1844.706097] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1845.417623] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1845.417639] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1845.419950] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x04EE, 92 bytes at 238[14]:4
> [ 1845.420020] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 1845.706045] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04EF, 12 bytes at 239[15]:4
> [ 1845.706092] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1846.706036] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04F0, 12 bytes at 240[16]:4
> [ 1846.706081] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1847.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04F1, 12 bytes at 241[17]:4
> [ 1847.706096] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1848.706045] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04F2, 12 bytes at 242[18]:4
> [ 1848.706096] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1849.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04F3, 12 bytes at 243[19]:4
> [ 1849.706094] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1850.424760] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1850.424780] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1850.433522] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1850.433536] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1850.433620] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1850.433628] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1850.455143] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1850.455154] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1850.455195] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1850.455204] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1850.608773] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1850.608788] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1850.706091] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1850.706108] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1850.706149] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04F4, 12 bytes at 244[20]:4
> [ 1850.706281] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1851.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04F5, 12 bytes at 245[21]:4
> [ 1851.706087] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1852.008659] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1852.008675] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1852.011857] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x04F6, 92 bytes at 246[22]:4
> [ 1852.011917] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 1852.706045] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04F7, 12 bytes at 247[23]:4
> [ 1852.706102] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1853.706046] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04F8, 12 bytes at 248[24]:4
> [ 1853.706099] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1854.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04F9, 12 bytes at 249[25]:4
> [ 1854.706090] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1855.219395] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1855.219410] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1855.221838] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x04FA, 92 bytes at 250[26]:4
> [ 1855.221901] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 1855.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04FB, 12 bytes at 251[27]:4
> [ 1855.706084] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1856.706049] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04FC, 12 bytes at 252[28]:4
> [ 1856.706102] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1857.706048] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04FD, 12 bytes at 253[29]:4
> [ 1857.706098] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1858.427933] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1858.427950] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1858.699480] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1858.699496] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1858.706046] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04FE, 12 bytes at 254[30]:4
> [ 1858.706094] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1859.706050] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04FF, 12 bytes at 255[31]:4
> [ 1859.706097] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1860.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0400, 12 bytes at 0[0]:4
> [ 1860.706096] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1861.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0401, 12 bytes at 1[1]:4
> [ 1861.706093] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1862.706050] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0402, 12 bytes at 2[2]:4
> [ 1862.706103] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1863.706044] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0403, 12 bytes at 3[3]:4
> [ 1863.706087] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1863.824049] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
> [ 1863.824061] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
> [ 1863.824068] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
> [ 1863.824079] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0404, 96 bytes at 4[4]:4
> [ 1863.824147] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
> [ 1863.824175] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
> [ 1863.824182] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
> [ 1863.824189] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
> [ 1863.824198] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
> [ 1863.824206] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
> [ 1863.824232] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1863.824246] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1864.706048] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0405, 12 bytes at 5[5]:4
> [ 1864.706098] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1865.706046] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0406, 12 bytes at 6[6]:4
> [ 1865.706098] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1866.706048] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0407, 12 bytes at 7[7]:4
> [ 1866.706097] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1867.553007] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1867.553033] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1867.553103] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
> [ 1867.553113] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
> [ 1867.553120] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
> [ 1867.553131] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0408, 96 bytes at 8[8]:4
> [ 1867.553178] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
> [ 1867.553234] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
> [ 1867.553242] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
> [ 1867.553249] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
> [ 1867.553258] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
> [ 1867.553265] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
> [ 1867.553281] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1867.553290] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1867.706044] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0409, 12 bytes at 9[9]:4
> [ 1867.706090] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1868.706049] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x040A, 12 bytes at 10[10]:4
> [ 1868.706095] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1869.706048] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x040B, 12 bytes at 11[11]:4
> [ 1869.706097] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1870.661657] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1870.661672] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1870.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x040C, 12 bytes at 12[12]:4
> [ 1870.706091] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1871.706053] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x040D, 12 bytes at 13[13]:4
> [ 1871.706100] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1872.706045] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x040E, 12 bytes at 14[14]:4
> [ 1872.706094] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1873.706045] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x040F, 12 bytes at 15[15]:4
> [ 1873.706097] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1874.706052] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0410, 12 bytes at 16[16]:4
> [ 1874.706104] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1875.455331] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1875.455347] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1875.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0411, 12 bytes at 17[17]:4
> [ 1875.706089] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1876.706045] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0412, 12 bytes at 18[18]:4
> [ 1876.706090] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1877.308764] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1877.308786] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1877.309927] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1877.309940] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1877.311358] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0413, 92 bytes at 19[19]:4
> [ 1877.311420] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 1877.311487] iwlagn 0000:02:00.0: iwlagn_tx_agg_start on ra = 20:4e:7f:5b:2d:f5 tid = 0
request for aggregation queue

> [ 1877.311498] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
> [ 1877.311507] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
> [ 1877.311513] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
> [ 1877.311523] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0414, 96 bytes at 20[20]:4
> [ 1877.311576] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
> [ 1877.311596] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
> [ 1877.311603] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
> [ 1877.311610] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
> [ 1877.311619] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
> [ 1877.311626] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
> [ 1877.311656] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1877.311666] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1877.312549] ieee80211 phy0: U iwlagn_tx_queue_set_status Activate BA Queue 10 on FIFO 1
activate BA queue

> [ 1877.312560] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0415, 92 bytes at 21[21]:4
> [ 1877.312626] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 1877.609276] ieee80211 phy0: I iwl_tt_handler Queueing thermal throttling work.
> [ 1877.655461] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1877.655476] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1877.656472] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1877.656483] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1877.706051] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0416, 12 bytes at 22[22]:4
> [ 1877.706103] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1877.916048] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1877.916064] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1877.922150] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1877.922160] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1877.922204] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1877.922212] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1877.925791] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1877.925803] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1878.254623] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1878.254638] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1878.534718] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1878.534727] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1878.840083] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1878.840100] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1880.292626] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1880.292642] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1880.433510] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1880.433530] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1880.433613] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1880.433622] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1880.459398] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1880.459408] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1880.459464] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1880.459472] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1880.459509] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1880.459517] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1880.464581] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1880.464592] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1880.593667] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1880.593682] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1880.611348] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1880.611358] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1881.263179] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1881.263195] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1881.265549] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0417, 92 bytes at 23[23]:4
> [ 1881.265604] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 1882.414156] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1882.414171] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1883.706048] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0418, 12 bytes at 24[24]:4
> [ 1883.706101] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1884.706046] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0419, 12 bytes at 25[25]:4
> [ 1884.706091] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1885.706049] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x041A, 12 bytes at 26[26]:4
> [ 1885.706096] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1886.706053] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x041B, 12 bytes at 27[27]:4
> [ 1886.706107] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1887.552062] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
> [ 1887.552075] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
> [ 1887.552082] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
> [ 1887.552092] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x041C, 96 bytes at 28[28]:4
> [ 1887.552153] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
> [ 1887.552171] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
> [ 1887.552177] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
> [ 1887.552185] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
> [ 1887.552193] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
> [ 1887.552200] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
> [ 1887.552223] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1887.552235] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1887.552663] ieee80211 phy0: U iwlagn_tx_queue_set_status Deactivate AC/CMD Queue 10 on FIFO 1
deactivate BA queue

> [ 1887.706047] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x041D, 12 bytes at 29[29]:4
> [ 1887.706094] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1888.706051] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x041E, 12 bytes at 30[30]:4
> [ 1888.706097] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1888.799055] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1888.799069] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1888.799132] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
> [ 1888.799141] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
> [ 1888.799147] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
> [ 1888.799158] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x041F, 96 bytes at 31[31]:4
> [ 1888.799253] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
> [ 1888.799281] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
> [ 1888.799287] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
> [ 1888.799294] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
> [ 1888.799303] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
> [ 1888.799310] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
> [ 1888.799325] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1888.799333] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1888.841076] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1888.841091] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1889.706045] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0420, 12 bytes at 32[0]:4
> [ 1889.706093] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1890.706047] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0421, 12 bytes at 33[1]:4
> [ 1890.706099] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1891.489353] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1891.489368] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1891.706051] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0422, 12 bytes at 34[2]:4
> [ 1891.706103] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1892.706045] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0423, 12 bytes at 35[3]:4
> [ 1892.706102] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1893.706044] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0424, 12 bytes at 36[4]:4
> [ 1893.706091] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1894.706050] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0425, 12 bytes at 37[5]:4
> [ 1894.706102] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1894.834376] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1894.834393] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1895.091105] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1895.091120] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1895.470781] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1895.470798] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1895.474990] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0426, 92 bytes at 38[6]:4
> [ 1895.475046] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 1895.706049] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0427, 12 bytes at 39[7]:4
> [ 1895.706106] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1896.706054] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0428, 12 bytes at 40[8]:4
> [ 1896.706102] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1897.706048] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0429, 12 bytes at 41[9]:4
> [ 1897.706092] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1898.706044] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x042A, 12 bytes at 42[10]:4
> [ 1898.706091] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1899.706048] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x042B, 12 bytes at 43[11]:4
> [ 1899.706097] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1900.608072] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
> [ 1900.608084] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
> [ 1900.608091] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
> [ 1900.608102] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x042C, 96 bytes at 44[12]:4
> [ 1900.608165] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
> [ 1900.608193] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
> [ 1900.608200] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
> [ 1900.608207] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
> [ 1900.608216] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
> [ 1900.608223] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
> [ 1900.608245] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1900.608256] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1900.706049] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x042D, 12 bytes at 45[13]:4
> [ 1900.706098] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1901.706049] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x042E, 12 bytes at 46[14]:4
> [ 1901.706098] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1902.476806] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1902.476822] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1902.476886] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
> [ 1902.476897] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
> [ 1902.476904] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
> [ 1902.476915] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x042F, 96 bytes at 47[15]:4
> [ 1902.476967] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
> [ 1902.476996] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
> [ 1902.477034] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
> [ 1902.477041] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
> [ 1902.477050] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
> [ 1902.477058] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
> [ 1902.477074] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1902.477083] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1902.482476] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0430, 92 bytes at 48[16]:4
> [ 1902.482538] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 1903.098266] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1903.098281] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1904.706051] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0431, 12 bytes at 49[17]:4
> [ 1904.706106] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1905.706048] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0432, 12 bytes at 50[18]:4
> [ 1905.706092] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1906.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0433, 12 bytes at 51[19]:4
> [ 1906.706090] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1907.706053] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0434, 12 bytes at 52[20]:4
> [ 1907.706105] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1907.727112] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1907.727127] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1908.706048] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0435, 12 bytes at 53[21]:4
> [ 1908.706098] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1908.967166] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1908.967181] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1910.441800] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1910.441819] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1910.441903] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1910.441912] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1910.467178] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1910.467195] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1910.467239] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1910.467247] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1910.805083] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1910.805098] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1910.807430] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0436, 92 bytes at 54[22]:4
> [ 1910.807492] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 1910.818068] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1910.818078] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1910.820708] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0437, 92 bytes at 55[23]:4
> [ 1910.820769] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 1910.822057] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1910.822066] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1910.825056] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1910.825067] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1911.520103] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1911.520120] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1911.532065] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1911.532076] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1911.532091] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1911.532098] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1911.592091] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1911.592110] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1912.706049] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0438, 12 bytes at 56[24]:4
> [ 1912.706101] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1912.731535] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1912.731548] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1912.746745] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1912.746759] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1912.749084] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0439, 92 bytes at 57[25]:4
> [ 1912.749136] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 1913.080600] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1913.080615] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1913.082914] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x043A, 92 bytes at 58[26]:4
> [ 1913.082977] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 1913.128809] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1913.128822] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1913.706051] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x043B, 12 bytes at 59[27]:4
> [ 1913.706105] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1913.769067] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1913.769082] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1913.780493] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1913.780504] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1913.896863] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1913.896878] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1915.180431] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1915.180446] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1915.432754] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1915.432772] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1916.706047] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x043C, 12 bytes at 60[28]:4
> [ 1916.706098] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1916.815043] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1916.815058] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1916.834310] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1916.834323] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1916.836631] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x043D, 92 bytes at 61[29]:4
> [ 1916.836693] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 1917.706049] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x043E, 12 bytes at 62[30]:4
> [ 1917.706100] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1917.878107] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1917.878125] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1917.880440] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x043F, 92 bytes at 63[31]:4
> [ 1917.880502] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 1919.706049] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0440, 12 bytes at 64[0]:4
> [ 1919.706093] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1920.706049] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0441, 12 bytes at 65[1]:4
> [ 1920.706103] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1921.263898] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1921.263913] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1921.706054] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0442, 12 bytes at 66[2]:4
> [ 1921.706105] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1922.706046] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0443, 12 bytes at 67[3]:4
> [ 1922.706095] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1923.706044] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0444, 12 bytes at 68[4]:4
> [ 1923.706091] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1924.351429] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1924.351446] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1924.351534] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1924.351543] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1924.706050] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0445, 12 bytes at 69[5]:4
> [ 1924.706100] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1925.706050] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0446, 12 bytes at 70[6]:4
> [ 1925.706100] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1925.833707] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1925.833723] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1926.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0447, 12 bytes at 71[7]:4
> [ 1926.706088] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1926.752205] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1926.752223] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1926.754873] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0448, 92 bytes at 72[8]:4
> [ 1926.754932] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 1926.754994] iwlagn 0000:02:00.0: iwlagn_tx_agg_start on ra = 20:4e:7f:5b:2d:f5 tid = 0

create aggregation queue again

> [ 1926.755035] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
> [ 1926.755049] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
> [ 1926.755060] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
> [ 1926.755074] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0449, 96 bytes at 73[9]:4
> [ 1926.755127] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
> [ 1926.755164] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
> [ 1926.755176] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
> [ 1926.755187] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
> [ 1926.755201] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
> [ 1926.755213] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
> [ 1926.755249] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1926.755262] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1926.756067] ieee80211 phy0: U iwlagn_tx_queue_set_status Activate BA Queue 10 on FIFO 1

activate it 

> [ 1926.756102] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x044A, 92 bytes at 74[10]:4
> [ 1926.756165] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 1927.321288] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1927.321303] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1927.321462] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1927.321471] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1927.360086] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1927.360102] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1927.731495] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1927.731511] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1928.334093] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1928.334108] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1929.354345] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1929.354361] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1929.539337] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1929.539352] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1929.973481] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1929.973496] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1929.975675] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1929.975688] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1930.401657] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1930.401672] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1931.001857] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1931.001872] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1931.521436] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1931.521452] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1932.201662] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1932.201677] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1933.706048] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x044B, 12 bytes at 75[11]:4
> [ 1933.706098] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1934.340953] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1934.340969] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1934.706036] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x044C, 12 bytes at 76[12]:4
> [ 1934.706087] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1934.976402] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1934.976418] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1936.706045] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x044D, 12 bytes at 77[13]:4
> [ 1936.706092] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1937.083621] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1937.083637] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1937.085985] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x044E, 92 bytes at 78[14]:4
> [ 1937.086044] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 1937.622849] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1937.622864] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1937.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x044F, 12 bytes at 79[15]:4
> [ 1937.706090] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1938.706053] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0450, 12 bytes at 80[16]:4
> [ 1938.706110] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1939.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0451, 12 bytes at 81[17]:4
> [ 1939.706085] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1940.248100] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1940.248117] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1940.442749] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1940.442769] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1940.442850] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1940.442859] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1940.472856] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1940.472873] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1940.472941] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1940.472949] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1940.472987] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1940.472995] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1940.473890] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0452, 92 bytes at 82[18]:4
> [ 1940.473944] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 1940.706046] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0453, 12 bytes at 83[19]:4
> [ 1940.706089] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1940.992111] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1940.992131] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1940.994334] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0454, 92 bytes at 84[20]:4
> [ 1940.994392] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 1941.344685] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1941.344706] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1941.876104] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1941.876122] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1941.892069] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1941.892080] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1942.032101] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1942.032119] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1943.040093] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1943.040113] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1943.048054] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1943.048064] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1945.332035] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1945.332050] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1945.355328] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1945.355341] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1945.357692] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0455, 92 bytes at 85[21]:4
> [ 1945.357754] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 1945.840094] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1945.840113] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1945.840908] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0456, 92 bytes at 86[22]:4
> [ 1945.840971] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 1947.458167] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1947.458183] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1948.706039] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0457, 12 bytes at 87[23]:4
> [ 1948.706087] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1949.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0458, 12 bytes at 88[24]:4
> [ 1949.706087] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1950.706049] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0459, 12 bytes at 89[25]:4
> [ 1950.706099] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1951.706049] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x045A, 12 bytes at 90[26]:4
> [ 1951.706098] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1952.592062] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
> [ 1952.592128] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
> [ 1952.592136] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
> [ 1952.592147] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x045B, 96 bytes at 91[27]:4
> [ 1952.592203] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
> [ 1952.592220] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
> [ 1952.592227] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
> [ 1952.592234] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
> [ 1952.592243] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
> [ 1952.592250] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
> [ 1952.592271] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1952.592282] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1952.592373] ieee80211 phy0: U iwlagn_tx_queue_set_status Deactivate AC/CMD Queue 10 on FIFO 1

deactivate again

> [ 1952.706047] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x045C, 12 bytes at 92[28]:4
> [ 1952.706091] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1953.649695] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1953.649710] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1953.649775] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
> [ 1953.649786] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
> [ 1953.649792] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
> [ 1953.649803] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x045D, 96 bytes at 93[29]:4
> [ 1953.649889] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
> [ 1953.649917] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
> [ 1953.649924] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
> [ 1953.649931] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
> [ 1953.649940] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
> [ 1953.649948] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
> [ 1953.649964] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1953.649973] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1953.706038] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x045E, 12 bytes at 94[30]:4
> [ 1953.706084] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1954.706048] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x045F, 12 bytes at 95[31]:4
> [ 1954.706097] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1955.706036] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0460, 12 bytes at 96[0]:4
> [ 1955.706090] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1955.900428] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1955.900445] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1956.205083] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1956.205100] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1956.706039] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0461, 12 bytes at 97[1]:4
> [ 1956.706090] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1956.814085] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1956.814102] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1958.022718] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1958.022733] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1960.706048] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0462, 12 bytes at 98[2]:4
> [ 1960.706097] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1961.706045] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0463, 12 bytes at 99[3]:4
> [ 1961.706089] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1962.520535] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1962.520550] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1962.706039] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0464, 12 bytes at 100[4]:4
> [ 1962.706084] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1963.706035] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0465, 12 bytes at 101[5]:4
> [ 1963.706085] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1964.706048] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0466, 12 bytes at 102[6]:4
> [ 1964.706096] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1965.580044] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1965.580059] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1965.582366] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0467, 92 bytes at 103[7]:4
> [ 1965.582427] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 1965.706047] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0468, 12 bytes at 104[8]:4
> [ 1965.706092] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1966.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0469, 12 bytes at 105[9]:4
> [ 1966.706085] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1967.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x046A, 12 bytes at 106[10]:4
> [ 1967.706096] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1968.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x046B, 12 bytes at 107[11]:4
> [ 1968.706100] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1969.531840] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1969.531856] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1969.534174] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x046C, 92 bytes at 108[12]:4
> [ 1969.534236] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 1969.706037] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x046D, 12 bytes at 109[13]:4
> [ 1969.706086] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1970.464880] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1970.464898] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1970.464979] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1970.464988] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1970.475151] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1970.475166] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1970.475209] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1970.475217] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1971.706044] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x046E, 12 bytes at 110[14]:4
> [ 1971.706100] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1971.813762] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1971.813778] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1972.706049] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x046F, 12 bytes at 111[15]:4
> [ 1972.706100] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1972.787565] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1972.787581] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1972.803369] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1972.803382] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1974.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0470, 12 bytes at 112[16]:4
> [ 1974.706091] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1975.122079] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1975.122094] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1975.124419] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0471, 92 bytes at 113[17]:4
> [ 1975.124484] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 1975.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0472, 12 bytes at 114[18]:4
> [ 1975.706093] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1976.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0473, 12 bytes at 115[19]:4
> [ 1976.706091] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1977.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0474, 12 bytes at 116[20]:4
> [ 1977.706101] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1977.794118] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1977.794132] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1977.796436] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0475, 92 bytes at 117[21]:4
> [ 1977.796497] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 1978.706038] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0476, 12 bytes at 118[22]:4
> [ 1978.706087] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1979.706038] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0477, 12 bytes at 119[23]:4
> [ 1979.706085] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1980.706039] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0478, 12 bytes at 120[24]:4
> [ 1980.706092] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1981.700758] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1981.700773] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1981.706038] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0479, 12 bytes at 121[25]:4
> [ 1981.706083] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1982.706046] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x047A, 12 bytes at 122[26]:4
> [ 1982.706095] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1983.706039] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x047B, 12 bytes at 123[27]:4
> [ 1983.706086] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1984.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x047C, 12 bytes at 124[28]:4
> [ 1984.706095] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1985.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x047D, 12 bytes at 125[29]:4
> [ 1985.706093] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1986.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x047E, 12 bytes at 126[30]:4
> [ 1986.706088] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1986.832059] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
> [ 1986.832071] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
> [ 1986.832079] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
> [ 1986.832090] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x047F, 96 bytes at 127[31]:4
> [ 1986.832157] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
> [ 1986.832176] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
> [ 1986.832182] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
> [ 1986.832190] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
> [ 1986.832198] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
> [ 1986.832206] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
> [ 1986.832230] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1986.832242] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1987.706039] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0480, 12 bytes at 128[0]:4
> [ 1987.706085] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1988.706049] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0481, 12 bytes at 129[1]:4
> [ 1988.706099] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1989.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0482, 12 bytes at 130[2]:4
> [ 1989.706096] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1989.979438] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1989.979455] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1990.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0483, 12 bytes at 131[3]:4
> [ 1990.706091] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1991.656137] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1991.656152] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1991.656223] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
> [ 1991.656233] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
> [ 1991.656240] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
> [ 1991.656251] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0484, 96 bytes at 132[4]:4
> [ 1991.656296] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
> [ 1991.656325] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
> [ 1991.656331] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
> [ 1991.656339] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
> [ 1991.656347] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
> [ 1991.656355] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
> [ 1991.656371] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1991.656380] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1992.465208] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1992.465227] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1993.706049] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0485, 12 bytes at 133[5]:4
> [ 1993.706099] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1994.706049] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0486, 12 bytes at 134[6]:4
> [ 1994.706098] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1994.912276] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1994.912293] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1994.912375] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1994.912384] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1994.914610] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0487, 92 bytes at 135[7]:4
> [ 1994.914666] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 1994.918044] iwlagn 0000:02:00.0: iwlagn_tx_agg_start on ra = 20:4e:7f:5b:2d:f5 tid = 0
> [ 1994.918055] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
> [ 1994.918063] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
> [ 1994.918070] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
> [ 1994.918080] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0488, 96 bytes at 136[8]:4
> [ 1994.918124] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
> [ 1994.918151] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
> [ 1994.918158] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
> [ 1994.918165] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
> [ 1994.918173] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
> [ 1994.918181] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
> [ 1994.918211] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1994.918221] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1994.919023] ieee80211 phy0: U iwlagn_tx_queue_set_status Activate BA Queue 10 on FIFO 1
> [ 1994.919056] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0489, 92 bytes at 137[9]:4
> [ 1994.919108] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 1995.249127] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1995.249144] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1995.291073] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1995.291089] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1995.509758] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1995.509775] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1995.706048] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x048A, 12 bytes at 138[10]:4
> [ 1995.706097] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 1996.031601] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1996.031618] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1996.488174] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1996.488189] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1996.530075] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1996.530090] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1996.759876] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1996.759891] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1996.820924] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1996.820939] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1997.002597] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1997.002613] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1997.002772] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1997.002781] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1997.006693] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1997.006703] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1997.076152] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1997.076167] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1997.275594] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1997.275606] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1997.277387] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1997.277398] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1997.277631] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1997.277637] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1997.277652] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1997.277655] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1997.295858] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1997.295871] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1997.392307] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1997.392324] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1997.493337] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1997.493352] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1997.536093] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1997.536107] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1998.040612] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1998.040627] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1998.058060] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1998.058070] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1998.093459] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1998.093474] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1998.367709] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1998.367725] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1998.827437] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1998.827453] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1999.100107] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1999.100123] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1999.242108] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1999.242123] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1999.293558] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1999.293572] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1999.585919] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1999.585936] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 1999.588305] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x048B, 92 bytes at 139[11]:4
> [ 1999.588361] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 1999.903264] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 1999.903280] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2000.471851] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2000.471871] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2000.471958] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2000.471967] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2000.504106] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2000.504118] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2000.504177] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2000.504185] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2000.504221] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2000.504229] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2002.007261] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2002.007280] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2002.111519] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2002.111535] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2002.277165] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2002.277184] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2002.277212] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2002.277219] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2002.277465] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x048C, 92 bytes at 140[12]:4
> [ 2002.277521] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 2002.376314] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2002.376330] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2002.378757] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x048D, 92 bytes at 141[13]:4
> [ 2002.378818] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 2002.756882] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2002.756897] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2002.776539] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2002.776550] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2004.336149] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2004.336165] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2004.586956] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2004.586972] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2004.704369] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2004.704387] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2005.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x048E, 12 bytes at 142[14]:4
> [ 2005.706097] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2006.406676] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2006.406692] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2006.706093] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x048F, 12 bytes at 143[15]:4
> [ 2006.706146] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2007.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0490, 12 bytes at 144[16]:4
> [ 2007.706094] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2008.382921] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2008.382936] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2008.646471] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2008.646487] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2008.647306] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2008.647317] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2008.648836] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0491, 92 bytes at 145[17]:4
> [ 2008.648888] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 2008.706039] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0492, 12 bytes at 146[18]:4
> [ 2008.706087] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2009.706048] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0493, 12 bytes at 147[19]:4
> [ 2009.706093] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2010.706045] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0494, 12 bytes at 148[20]:4
> [ 2010.706100] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2010.859199] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2010.859214] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2010.861568] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0495, 92 bytes at 149[21]:4
> [ 2010.861627] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 2011.253547] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2011.253562] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2011.706029] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0496, 12 bytes at 150[22]:4
> [ 2011.706072] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2012.706023] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0497, 12 bytes at 151[23]:4
> [ 2012.706051] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2012.990044] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2012.990056] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2013.302846] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2013.302856] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2013.706022] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0498, 12 bytes at 152[24]:4
> [ 2013.706053] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2014.706023] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0499, 12 bytes at 153[25]:4
> [ 2014.706060] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2015.104854] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2015.104864] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2015.706022] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x049A, 12 bytes at 154[26]:4
> [ 2015.706055] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2016.706024] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x049B, 12 bytes at 155[27]:4
> [ 2016.706058] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2016.815751] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2016.815761] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2016.815776] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2016.815780] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2016.854080] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2016.854097] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2016.963965] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2016.963983] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2016.966774] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x049C, 92 bytes at 156[28]:4
> [ 2016.966840] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 2017.706054] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x049D, 12 bytes at 157[29]:4
> [ 2017.706093] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2018.497521] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2018.497537] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2018.499888] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x049E, 92 bytes at 158[30]:4
> [ 2018.499951] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 2018.873671] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2018.873685] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2020.495315] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2020.495330] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2020.677924] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2020.677933] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2020.678516] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2020.678522] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2021.706054] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x049F, 12 bytes at 159[31]:4
> [ 2021.706095] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2022.501199] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2022.501216] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2022.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04A0, 12 bytes at 160[0]:4
> [ 2022.706096] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2023.607299] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2023.607314] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2024.323497] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2024.323512] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2025.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04A1, 12 bytes at 161[1]:4
> [ 2025.706088] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2026.706038] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04A2, 12 bytes at 162[2]:4
> [ 2026.706086] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2027.504203] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2027.504223] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2027.706049] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04A3, 12 bytes at 163[3]:4
> [ 2027.706099] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2028.032095] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2028.032116] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2029.151238] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2029.151254] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2029.153607] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x04A4, 92 bytes at 164[4]:4
> [ 2029.153671] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 2029.552586] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2029.552603] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2029.554961] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x04A5, 92 bytes at 165[5]:4
> [ 2029.555034] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 2030.473700] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2030.473718] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2030.473799] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2030.473807] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2030.511979] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2030.511996] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2030.512077] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2030.512086] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2030.538024] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2030.538034] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2030.541101] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2030.541114] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2031.706051] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04A6, 12 bytes at 166[6]:4
> [ 2031.706103] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2031.984441] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2031.984456] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2032.024635] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2032.024654] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2032.027261] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x04A7, 92 bytes at 167[7]:4
> [ 2032.027442] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2032.027453] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2032.027474] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 2032.706050] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04A8, 12 bytes at 168[8]:4
> [ 2032.706100] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2033.204377] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2033.204394] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2034.487942] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2034.487958] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2035.706037] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04A9, 12 bytes at 169[9]:4
> [ 2035.706089] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2036.040131] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2036.040147] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2036.706039] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04AA, 12 bytes at 170[10]:4
> [ 2036.706093] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2037.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04AB, 12 bytes at 171[11]:4
> [ 2037.706095] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2038.706046] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04AC, 12 bytes at 172[12]:4
> [ 2038.706092] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2039.052595] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2039.052610] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2040.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04AD, 12 bytes at 173[13]:4
> [ 2040.706098] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2041.282924] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2041.282934] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2041.706044] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04AE, 12 bytes at 174[14]:4
> [ 2041.706093] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2042.706038] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04AF, 12 bytes at 175[15]:4
> [ 2042.706085] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2043.617063] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2043.617080] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2043.706045] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04B0, 12 bytes at 176[16]:4
> [ 2043.706094] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2044.680909] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2044.680924] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2045.007229] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2045.007249] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2045.558192] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2045.558203] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2046.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04B1, 12 bytes at 177[17]:4
> [ 2046.706090] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2046.928100] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2046.928116] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2047.669431] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2047.669450] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2047.671866] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x04B2, 92 bytes at 178[18]:4
> [ 2047.671927] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 2047.706047] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04B3, 12 bytes at 179[19]:4
> [ 2047.706092] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2047.783749] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2047.783764] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2049.706049] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04B4, 12 bytes at 180[20]:4
> [ 2049.706099] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2050.219412] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2050.219428] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2050.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04B5, 12 bytes at 181[21]:4
> [ 2050.706095] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2051.492389] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2051.492405] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2052.706045] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04B6, 12 bytes at 182[22]:4
> [ 2052.706102] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2052.853921] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2052.853938] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2053.706047] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04B7, 12 bytes at 183[23]:4
> [ 2053.706103] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2054.416903] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2054.416918] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2055.636643] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2055.636661] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2056.518735] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2056.518752] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2056.522787] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x04B8, 92 bytes at 184[24]:4
> [ 2056.522849] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 2057.027077] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2057.027095] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2057.029457] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x04B9, 92 bytes at 185[25]:4
> [ 2057.029515] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 2057.039425] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2057.039442] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2057.296096] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2057.296113] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2057.810103] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2057.810121] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2058.836104] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2058.836122] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2058.854294] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2058.854305] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2059.215934] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2059.215950] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2059.218656] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2059.218669] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2059.476658] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2059.476674] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2059.479020] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x04BA, 92 bytes at 186[26]:4
> [ 2059.479076] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 2060.001696] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2060.001711] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2060.004064] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x04BB, 92 bytes at 187[27]:4
> [ 2060.004122] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 2060.485183] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2060.485196] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2060.485241] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2060.485245] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2060.523141] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2060.523157] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2060.523218] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2060.523226] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2060.523264] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2060.523272] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2060.922115] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2060.922130] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2061.053943] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2061.053959] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2061.364932] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2061.364949] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2061.366344] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2061.366356] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2061.367295] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x04BC, 92 bytes at 188[28]:4
> [ 2061.367347] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 2062.706049] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04BD, 12 bytes at 189[29]:4
> [ 2062.706099] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2063.276240] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2063.276255] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2063.278951] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x04BE, 92 bytes at 190[30]:4
> [ 2063.279037] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 2063.291471] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2063.291481] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2063.480467] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2063.480483] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2063.706047] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04BF, 12 bytes at 191[31]:4
> [ 2063.706091] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2063.774705] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2063.774719] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2063.894388] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2063.894402] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2063.896863] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2063.896875] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2064.800093] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2064.800109] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2064.816059] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2064.816069] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2064.882836] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2064.882853] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2065.609099] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2065.609116] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2065.610155] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x04C0, 92 bytes at 192[0]:4
> [ 2065.610211] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 2066.106835] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2066.106852] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2066.109223] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x04C1, 92 bytes at 193[1]:4
> [ 2066.109285] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 2066.665345] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2066.665365] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2066.668235] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2066.668249] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2067.291747] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2067.291763] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2067.399832] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2067.399843] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2068.244444] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2068.244461] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2068.247107] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x04C2, 92 bytes at 194[2]:4
> [ 2068.247170] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 2068.801436] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2068.801452] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2069.441825] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2069.441841] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2069.474354] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2069.474372] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2070.698379] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2070.698395] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2071.296084] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2071.296101] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2071.586708] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2071.586726] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2071.684112] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2071.684125] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2072.706048] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04C3, 12 bytes at 195[3]:4
> [ 2072.706092] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2073.376113] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2073.376131] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2073.706045] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04C4, 12 bytes at 196[4]:4
> [ 2073.706092] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2073.950217] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2073.950234] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2074.805627] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2074.805643] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2075.522083] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2075.522099] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2076.208097] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2076.208116] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2076.593642] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2076.593657] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2076.840033] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2076.840066] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2076.843512] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x04C5, 92 bytes at 197[5]:4
> [ 2076.843576] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 2077.389409] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2077.389426] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2077.735221] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2077.735236] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2078.026279] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2078.026298] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2079.125515] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2079.125530] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2080.482794] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2080.482809] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2081.594981] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2081.595033] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2082.706047] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04C6, 12 bytes at 198[6]:4
> [ 2082.706098] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2082.799735] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2082.799750] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2083.706051] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04C7, 12 bytes at 199[7]:4
> [ 2083.706101] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2083.777527] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2083.777542] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2083.780570] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x04C8, 92 bytes at 200[8]:4
> [ 2083.780631] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 2085.149250] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2085.149285] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2085.151646] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x04C9, 92 bytes at 201[9]:4
> [ 2085.151711] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 2085.248085] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2085.248102] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2085.872461] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2085.872478] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2085.918078] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2085.918095] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2087.477135] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2087.477151] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2087.811046] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2087.811062] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2088.423430] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2088.423446] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2088.429062] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2088.429076] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2088.593089] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2088.593105] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2089.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04CA, 12 bytes at 202[10]:4
> [ 2089.706135] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2090.504119] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2090.504135] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2090.504224] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2090.504233] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2090.506506] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x04CB, 92 bytes at 203[11]:4
> [ 2090.506559] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 2090.544241] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2090.544268] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2090.544317] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2090.544321] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2090.544648] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x04CC, 92 bytes at 204[12]:4
> [ 2090.544698] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 2090.706037] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04CD, 12 bytes at 205[13]:4
> [ 2090.706099] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2091.053563] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2091.053578] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2091.343698] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2091.343713] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2091.350800] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2091.350819] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2092.706048] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04CE, 12 bytes at 206[14]:4
> [ 2092.706098] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2093.298433] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2093.298448] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2093.340048] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2093.340062] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2093.706053] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04CF, 12 bytes at 207[15]:4
> [ 2093.706095] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2094.113215] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2094.113232] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2094.124487] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2094.124498] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2095.706048] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04D0, 12 bytes at 208[16]:4
> [ 2095.706100] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2096.645773] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2096.645784] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2096.706039] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04D1, 12 bytes at 209[17]:4
> [ 2096.706090] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2097.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04D2, 12 bytes at 210[18]:4
> [ 2097.706086] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2098.706054] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04D3, 12 bytes at 211[19]:4
> [ 2098.706101] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2099.108958] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2099.108974] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2099.111330] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x04D4, 92 bytes at 212[20]:4
> [ 2099.111392] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 2099.154072] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2099.154088] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2099.605091] ieee80211 phy0: U iwlagn_mac_set_key enter
> [ 2099.605102] ieee80211 phy0: U iwl_scan_cancel_timeout Scan cancel timeout
> [ 2099.605108] ieee80211 phy0: U iwl_do_scan_abort Not performing scan to abort
> [ 2099.605116] ieee80211 phy0: U iwlagn_mac_set_key disable hwcrypto key
> [ 2099.605121] ieee80211 phy0: U iwlagn_mac_set_key leave
> [ 2099.605228] ieee80211 phy0: U iwlagn_mac_set_key enter
> [ 2099.605234] ieee80211 phy0: U iwl_scan_cancel_timeout Scan cancel timeout
> [ 2099.605240] ieee80211 phy0: U iwl_do_scan_abort Not performing scan to abort
> [ 2099.605249] ieee80211 phy0: U iwl_send_add_sta Adding sta 15 (ff:ff:ff:ff:ff:ff) synchronously
> [ 2099.605257] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
> [ 2099.605263] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
> [ 2099.605274] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x04D5, 96 bytes at 213[21]:4
> [ 2099.605325] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
> [ 2099.605339] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 15
> [ 2099.605342] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
> [ 2099.605345] ieee80211 phy0: U iwl_sta_ucode_activate STA id 15 addr ff:ff:ff:ff:ff:ff already present in uCode (according to driver)
> [ 2099.605350] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 15 addr ff:ff:ff:ff:ff:ff
> [ 2099.605353] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer ff:ff:ff:ff:ff:ff
> [ 2099.605357] ieee80211 phy0: U iwlagn_mac_set_key enable hwcrypto key
> [ 2099.605360] ieee80211 phy0: U iwlagn_mac_set_key leave
> [ 2099.605396] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2099.605403] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2099.706044] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04D6, 12 bytes at 214[22]:4
> [ 2099.706098] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2100.557338] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2100.557354] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2101.361205] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2101.361221] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2101.401395] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2101.401407] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2102.706038] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04D7, 12 bytes at 215[23]:4
> [ 2102.706084] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2103.548217] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2103.548235] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2103.556919] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2103.556936] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2103.706046] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04D8, 12 bytes at 216[24]:4
> [ 2103.706110] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2103.995774] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2103.995789] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2103.998145] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x04D9, 92 bytes at 217[25]:4
> [ 2103.998207] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 2105.706053] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04DA, 12 bytes at 218[26]:4
> [ 2105.706098] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2105.910295] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2105.910313] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2106.332994] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2106.333037] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2106.706050] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04DB, 12 bytes at 219[27]:4
> [ 2106.706090] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2107.706049] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04DC, 12 bytes at 220[28]:4
> [ 2107.706091] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2107.883515] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2107.883533] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2108.260968] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2108.260983] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2108.706049] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04DD, 12 bytes at 221[29]:4
> [ 2108.706105] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2109.706039] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04DE, 12 bytes at 222[30]:4
> [ 2109.706091] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2110.096637] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2110.096653] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2110.695910] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2110.695924] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2110.706050] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04DF, 12 bytes at 223[31]:4
> [ 2110.706096] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2111.706049] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04E0, 12 bytes at 224[0]:4
> [ 2111.706096] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2112.361460] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2112.361475] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2112.642226] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2112.642242] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2112.644590] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x04E1, 92 bytes at 225[1]:4
> [ 2112.644653] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 2112.706048] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04E2, 12 bytes at 226[2]:4
> [ 2112.706095] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2113.706038] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04E3, 12 bytes at 227[3]:4
> [ 2113.706093] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2114.440994] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2114.441042] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2114.706038] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04E4, 12 bytes at 228[4]:4
> [ 2114.706086] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2115.706044] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04E5, 12 bytes at 229[5]:4
> [ 2115.706089] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2116.243226] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2116.243241] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2116.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04E6, 12 bytes at 230[6]:4
> [ 2116.706096] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2116.798167] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2116.798184] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2118.706054] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04E7, 12 bytes at 231[7]:4
> [ 2118.706099] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2119.056658] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2119.056674] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2119.440448] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2119.440464] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2119.706048] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04E8, 12 bytes at 232[8]:4
> [ 2119.706096] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2120.530685] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2120.530702] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2120.530784] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2120.530792] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2120.546165] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2120.546181] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2120.546247] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2120.546255] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2120.546295] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2120.546303] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2120.546664] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x04E9, 92 bytes at 233[9]:4
> [ 2120.546725] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
> [ 2121.706050] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04EA, 12 bytes at 234[10]:4
> [ 2121.706129] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2122.071567] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2122.071584] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2122.706047] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04EB, 12 bytes at 235[11]:4
> [ 2122.706099] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
> [ 2123.090020] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2123.090035] ieee80211 phy0: I iwlagn_mac_tx leave
> [ 2123.510809] ieee80211 phy0: I iwlagn_mac_tx enter
> [ 2123.510826] ieee80211 phy0: I iwlagn_mac_tx leave
> 
> 
> On Mon, 14 Nov 2011 07:10:10 -0800
> wwguy <wey-yi.w.guy@intel.com> wrote:
> 
> > Hi Lars,
> >
> > On Mon, 2011-11-14 at 04:16 -0800, Lars Schotte wrote:
> > > hi,
> > >
> > > i get always such aggreggation messages every 35 seconds since the
> > > update from 3.0.8 to 3.0.9, so something is wrong there.
> > >
> > > [  238.280312] iwlagn 0000:02:00.0: Aggregation not enabled for tid
> > > 0 because load = 0 [  335.575672] iwlagn 0000:02:00.0:
> > > iwlagn_tx_agg_start on ra = 20:4e:7f:5b:2d:f5 tid = 0 [  400.605027]
> > > iwlagn 0000:02:00.0: iwlagn_tx_agg_start on ra = 20:4e:7f:5b:2d:f5
> > > tid = 0 [  532.418136] iwlagn 0000:02:00.0: iwlagn_tx_agg_start on
> > > ra = 20:4e:7f:5b:2d:f5 tid = 0 [  590.173035] iwlagn 0000:02:00.0:
> > > iwlagn_tx_agg_start on ra = 20:4e:7f:5b:2d:f5 tid = 0 [  616.193084]
> > > iwlagn 0000:02:00.0: iwlagn_tx_agg_start on ra = 20:4e:7f:5b:2d:f5
> > > tid = 0 [  934.882300] iwlagn 0000:02:00.0: iwlagn_tx_agg_start on
> > > ra = 20:4e:7f:5b:2d:f5 tid = 0 [  983.877888] iwlagn 0000:02:00.0:
> > > iwlagn_tx_agg_start on ra = 20:4e:7f:5b:2d:f5 tid = 0 [ 1048.354089]
> > > iwlagn 0000:02:00.0: iwlagn_tx_agg_start on ra = 20:4e:7f:5b:2d:f5
> > > tid = 0 [ 1137.254697] iwlagn 0000:02:00.0: iwlagn_tx_agg_start on
> > > ra = 20:4e:7f:5b:2d:f5 tid = 0 [ 1173.956035] iwlagn 0000:02:00.0:
> > > iwlagn_tx_agg_start on ra = 20:4e:7f:5b:2d:f5 tid = 0
> >
> > hmm, it should not happen, are you still seeing this in the latest
> > driver? if does, could you load the driver with debug flag = 0x43fff
> > to help us understand what is happening?
> >
> > >
> > > then there are no iwlagn drivers in 3.2 any more, but iwlwifi,
> > > what's the difference between these two drivers?
> > >
> > We are in the process of re-architect and improve the flexible and
> > quality of our existing driver. As today, "iwlwifi" should the same as
> > "iwlagn" and you can use either one (iwlwifi or iwlagn), "iwlagn" just
> > an alias of "iwlwifi". Moving forward, we will deprecate the "iwlagn"
> > name after we complete the implementation of next generation of Intel
> > WiFi driver.
> >
> > Thanks
> > Wey
> >
> >
> >
> 
> 
> 
> --
> Lars Schotte
> @ Hana (F16)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


