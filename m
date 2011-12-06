Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37796 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932780Ab1LFBaX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Dec 2011 20:30:23 -0500
Received: by ghrr1 with SMTP id r1so4985523ghr.19
        for <linux-wireless@vger.kernel.org>; Mon, 05 Dec 2011 17:30:23 -0800 (PST)
Message-ID: <4EDD7026.9000308@lwfinger.net> (sfid-20111206_023029_009358_18963AD7)
Date: Mon, 05 Dec 2011 19:30:14 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Strange code in routine wlc_phy_radio_init_2057()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In looking at the support code for Type 2057 radios in brcmsmac, I noticed the 
following routine:

static void wlc_phy_radio_init_2057(struct brcms_phy *pi)
{
         struct radio_20xx_regs *regs_2057_ptr = NULL;

         if (NREV_IS(pi->pubpi.phy_rev, 7)) {
                 regs_2057_ptr = regs_2057_rev4;
         } else if (NREV_IS(pi->pubpi.phy_rev, 8)
                    || NREV_IS(pi->pubpi.phy_rev, 9)) {
                 switch (pi->pubpi.radiorev) {
                 case 5:
                         if (pi->pubpi.radiover == 0x0)
                                 regs_2057_ptr = regs_2057_rev5;
                         else if (pi->pubpi.radiover == 0x1)
                                 regs_2057_ptr = regs_2057_rev5v1;
                         else
                                 break;
                 case 7:
                         regs_2057_ptr = regs_2057_rev7;
                         break;
                 case 8:
                         regs_2057_ptr = regs_2057_rev8;
                         break;
                 default:
                         break;
                 }
         }
         wlc_phy_init_radio_regs_allbands(pi, regs_2057_ptr);
}

I do not think that the code for phy revisions 8 or 9, and radio revision 5 is 
correct. When the radio version is 0, or 1, the case statement will fall through 
to the radio revision 7 case, thereby negating the logic that sets regs_2057_ptr 
for case 5.

I think the following patch will fix it:

Index: wireless-testing-new/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
+++ wireless-testing-new/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
@@ -19996,8 +19996,8 @@ static void wlc_phy_radio_init_2057(stru
                                 regs_2057_ptr = regs_2057_rev5;
                         else if (pi->pubpi.radiover == 0x1)
                                 regs_2057_ptr = regs_2057_rev5v1;
-                       else
-                               break;
+
+                       break;

                 case 7:


Larry
