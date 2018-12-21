Return-Path: <SRS0=l33s=O6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11A70C43387
	for <linux-wireless@archiver.kernel.org>; Fri, 21 Dec 2018 10:30:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC59921908
	for <linux-wireless@archiver.kernel.org>; Fri, 21 Dec 2018 10:30:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731222AbeLUKaD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 21 Dec 2018 05:30:03 -0500
Received: from relay-b01.edpnet.be ([212.71.1.221]:47294 "EHLO
        relay-b01.edpnet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730392AbeLUKaD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Dec 2018 05:30:03 -0500
X-Greylist: delayed 723 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Dec 2018 05:30:02 EST
X-ASG-Debug-ID: 1545387477-0a7ff577af86aaa0001-9xRsGE
Received: from zotac.vandijck-laurijssen.be (77.109.116.222.adsl.dyn.edpnet.net [77.109.116.222]) by relay-b01.edpnet.be with ESMTP id 6ALe684qJLYAviX7 for <linux-wireless@vger.kernel.org>; Fri, 21 Dec 2018 11:17:57 +0100 (CET)
X-Barracuda-Envelope-From: dev.kurt@vandijck-laurijssen.be
X-Barracuda-Effective-Source-IP: 77.109.116.222.adsl.dyn.edpnet.net[77.109.116.222]
X-Barracuda-Apparent-Source-IP: 77.109.116.222
Received: from x1.vandijck-laurijssen.be (74.250-240-81.adsl-static.isp.belgacom.be [81.240.250.74])
        by zotac.vandijck-laurijssen.be (Postfix) with ESMTPSA id 914296B3136
        for <linux-wireless@vger.kernel.org>; Fri, 21 Dec 2018 11:17:57 +0100 (CET)
Date:   Fri, 21 Dec 2018 11:17:56 +0100
From:   Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>
To:     linux-wireless@vger.kernel.org
Subject: question concerning Japan regulation and NO-OUTDOOR
Message-ID: <20181221101756.GA19960@x1.vandijck-laurijssen.be>
X-ASG-Orig-Subj: question concerning Japan regulation and NO-OUTDOOR
Mail-Followup-To: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
X-Barracuda-Connect: 77.109.116.222.adsl.dyn.edpnet.net[77.109.116.222]
X-Barracuda-Start-Time: 1545387477
X-Barracuda-URL: https://212.71.1.221:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 1893
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.5314 1.0000 0.7500
X-Barracuda-Spam-Score: 0.75
X-Barracuda-Spam-Status: No, SCORE=0.75 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=7.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.64207
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------------------------
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hey all,

I work on a project for an outdoor device equipped with a Ralink wifi
key. In order to get certified in Japan, we should be able to proof that
the device is not using the 5.2GHz bands since this band is limited to
indoor use only in Japan.
As I understood, 5.4GHz and up are allowed.

My first, rather rough, approach is to specify all 2.4GHz bands in
wpa_supplicant's global 'freq_list' parameter.
We found that our device still connect to 5GHz networks, I believe
because passive scanning allows 5GHz networks to be detected anyway.

2nd attempt, on top of the 1st, is to patch wpa_supplicant with:

diff --git a/wpa_supplicant/events.c b/wpa_supplicant/events.c
index 37d429d..c32aa1a 100644
--- a/wpa_supplicant/events.c
+++ b/wpa_supplicant/events.c
@@ -1223,6 +1223,13 @@ struct wpa_ssid * wpa_scan_res_match(struct wpa_supplicant *wpa_s,
 			continue;
 		}
 
+		if (!freq_allowed(wpa_s->conf->freq_list, bss->freq)) {
+			wpa_msg(wpa_s, MSG_INFO,
+				"frequency %u excluded", bss->freq);
+			wpa_dbg(wpa_s, MSG_DEBUG,
+				"   skip - avoid this frequency");
+			continue;
+		}
 		if (!freq_allowed(ssid->freq_list, bss->freq)) {
 			if (debug_print)
 				wpa_dbg(wpa_s, MSG_DEBUG,

In short, this enforces wpa_supplicant to honor the global freq_list
parameter for joining accesspoints, as it does for per-network
freq_lists.

Is this sufficient to avoid our chip to send on 5GHz band?

I also noticed some NO-OUTDOOR specifiers in the wireless regdb,
but not on the 5.2GHz bands for Japan.
I'm in the position to find out those details, and I'm willing to amend
in the upstream repository.
I do not yet see however how I can tell the kernel that it should limit
wifi regulation to outdoor use only. There seems no simple 'iw reg set
outdoor' or similar command. How is this done?

Thanks for your responses in advance,
Kurt
