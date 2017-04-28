Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:35619 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031811AbdD1Sw6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Apr 2017 14:52:58 -0400
Received: by mail-io0-f194.google.com with SMTP id d203so13318504iof.2
        for <linux-wireless@vger.kernel.org>; Fri, 28 Apr 2017 11:52:57 -0700 (PDT)
Subject: Re: [PATCH 06/10] rtlwifi: btcoex: 21a 2ant: run mechanism if status
 changes or auto adjust is set
To: =?UTF-8?B?6I6K5b2l5a6j?= <yhchuang@realtek.com>,
        Szuyitasi <szuyitasi@realtek.com>
References: <20170416190428.23857-1-Larry.Finger@lwfinger.net>
 <20170416190428.23857-7-Larry.Finger@lwfinger.net>
 <87bmrrbb8q.fsf@purkki.adurom.net>
 <F7CD281DE3E379468C6D07993EA72F8401533A7C@RTITMBSV07.realtek.com.tw>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <d02588ed-bf39-86a5-19ae-bbd3faafb3e7@lwfinger.net> (sfid-20170428_205304_698492_B1C2A89B)
Date: Fri, 28 Apr 2017 13:52:55 -0500
MIME-Version: 1.0
In-Reply-To: <F7CD281DE3E379468C6D07993EA72F8401533A7C@RTITMBSV07.realtek.com.tw>
Content-Type: multipart/mixed;
 boundary="------------C75F1C1C01FB12CCFBC61BC8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------C75F1C1C01FB12CCFBC61BC8
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

On 04/20/2017 08:30 AM, 莊彥宣 wrote:
> Dear SY,
>
> Linux kernel upstream 上面對於這種 ifdef 的方式是不認同的
> 能否用其他的方式來代替呢?
> 或是利用變數來控制。
>
> 另外如果default是跑哪邊，某一路只是for special case的話
> 可以先把其中一邊拿掉。
> 先上upstream 之後再來refine
>
>
> Best Regards,
> Tony
>
> -----Original Message-----
> From: Kalle Valo [mailto:kvalo@codeaurora.org]
> Sent: Thursday, April 20, 2017 6:54 PM
> To: Larry Finger
> Cc: linux-wireless@vger.kernel.org; 莊彥宣; Pkshih; Birming Chiu; Shaofu; Steven Ting
> Subject: Re: [PATCH 06/10] rtlwifi: btcoex: 21a 2ant: run mechanism if status changes or auto adjust is set
>
> Larry Finger <Larry.Finger@lwfinger.net> writes:
>
>> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
>>
>> The driver will periodically ask the coex, and the coex only runs the
>> mechanism when the status was changed or the auto adjust is set.
>>
>> Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> Cc: Pkshih <pkshih@realtek.com>
>> Cc: Birming Chiu <birming@realtek.com>
>> Cc: Shaofu <shaofu@realtek.com>
>> Cc: Steven Ting <steventing@realtek.com>
>
> [...]
>
>> @@ -4200,7 +4200,14 @@ void ex_btc8821a2ant_periodical(struct btc_coexist *btcoexist)
>>  			 "[BTCoex], ****************************************************************\n");
>>  	}
>>
>> +#ifdef BT_AUTO_REPORT_ONLY_8821A_2ANT
>>  	btc8821a2ant_query_bt_info(btcoexist);
>> +#else
>>  	btc8821a2ant_monitor_bt_ctr(btcoexist);
>>  	btc8821a2ant_monitor_wifi_ctr(btcoexist);
>> +
>> +	if (btc8821a2ant_is_wifi_status_changed(btcoexist) ||
>> +	    coex_dm->auto_tdma_adjust)
>> +		btc8821a2ant_run_coexist_mechanism(btcoexist);
>> +#endif
>
> This ifdef looks fishy. Why is it needed?
>
> In general I would expect to see ifdefs only for Kconfig options or defines which value comes from core kernel.
>
> --
> Kalle Valo

Tony,

Any resolution of this issue? I would really like to be able to submit the 50 
patches I have in my queue.

One thought I have is to add boolean variables auto_report_1ant and 
auto_report_2ant to struct btc_coexist. Then the testing of 
BT_AUTO_REPORT_ONLY_8821A_1ANT, etc. can be done with an if statement, not with 
the #if that is currently present.

Attached is a patch to fix halbtc8821a1ant.

Larry





--------------C75F1C1C01FB12CCFBC61BC8
Content-Type: text/x-patch;
 name="eliminate_BT_AUTO_REPORT_ONLY_8821A_1ANT.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="eliminate_BT_AUTO_REPORT_ONLY_8821A_1ANT.patch"

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
index 5e9f3b0f7a25..adb9306b1015 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
@@ -2116,6 +2116,7 @@ static void btc8821a1ant_init_hw_config(struct btc_coexist *btcoexist,
 void ex_btc8821a1ant_init_hwconfig(struct btc_coexist *btcoexist, bool wifionly)
 {
 	btc8821a1ant_init_hw_config(btcoexist, true, wifionly);
+	btcoexist->auto_report_1ant = false;
 }
 
 void ex_btc8821a1ant_init_coex_dm(struct btc_coexist *btcoexist)
@@ -2406,9 +2407,8 @@ void ex_btc8821a1ant_display_coex_info(struct btc_coexist *btcoexist)
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
 		 "\r\n %-35s = %d/ %d", "0x774(low-pri rx/tx)",
 		 coex_sta->low_priority_rx, coex_sta->low_priority_tx);
-#if (BT_AUTO_REPORT_ONLY_8821A_1ANT == 1)
-	btc8821a1ant_monitor_bt_ctr(btcoexist);
-#endif
+	if (btcoexist->auto_report_1ant)
+		btc8821a1ant_monitor_bt_ctr(btcoexist);
 	btcoexist->btc_disp_dbg_msg(btcoexist, BTC_DBG_DISP_COEX_STATISTICS);
 }
 
@@ -2964,10 +2964,10 @@ void ex_btc8821a1ant_periodical(struct btc_coexist *btcoexist)
 			 "[BTCoex], ****************************************************************\n");
 	}
 
-#if (BT_AUTO_REPORT_ONLY_8821A_1ANT == 0)
-	btc8821a1ant_query_bt_info(btcoexist);
-	btc8821a1ant_monitor_bt_ctr(btcoexist);
-#else
-	coex_sta->special_pkt_period_cnt++;
-#endif
+	if (!btcoexist->auto_report_1ant) {
+		btc8821a1ant_query_bt_info(btcoexist);
+		btc8821a1ant_monitor_bt_ctr(btcoexist);
+	} else {
+		coex_sta->special_pkt_period_cnt++;
+	}
 }
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.h
index 1bd1ebe3364e..eeaea9efd2f3 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.h
@@ -27,7 +27,6 @@
  * The following is for 8821A 1ANT BT Co-exist definition
  *===========================================
  */
-#define	BT_AUTO_REPORT_ONLY_8821A_1ANT				0
 
 #define	BT_INFO_8821A_1ANT_B_FTP	BIT7
 #define	BT_INFO_8821A_1ANT_B_A2DP	BIT6
@@ -170,6 +169,7 @@ struct coex_sta_8821a_1ant {
  * The following is interface which will notify coex module.
  *===========================================
  */
+bool btc8821a1ant_is_wifi_status_changed(struct btc_coexist *btcoexist);
 void ex_halbtc8821a1ant_init_hwconfig(struct btc_coexist *btcoexist);
 void ex_halbtc8821a1ant_init_coex_dm(struct btc_coexist *btcoexist);
 void ex_halbtc8821a1ant_ips_notify(struct btc_coexist *btcoexist, u8 type);
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
index c8271135aaaa..7a23432b0c55 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
@@ -496,6 +496,8 @@ struct btc_coexist {
 	enum btc_chip_interface	chip_interface;
 	struct btc_bt_link_info bt_link_info;
 
+	bool auto_report_1ant;
+	bool auto_report_2ant;
 	bool initilized;
 	bool stop_coex_dm;
 	bool manual_control;

--------------C75F1C1C01FB12CCFBC61BC8--
