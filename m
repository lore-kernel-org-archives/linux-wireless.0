Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:34000 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726343AbeHUMiX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Aug 2018 08:38:23 -0400
Date: Tue, 21 Aug 2018 11:18:59 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Grzegorz =?utf-8?Q?Duszy=C5=84ski?= <gfduszynski@gmail.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [RFC] cfg80211: let's wmm_rule be part of reg_rule structure
Message-ID: <20180821091858.GA9376@redhat.com> (sfid-20180821_111904_478927_7BAE7C81)
References: <20180821074020.GA28952@redhat.com>
 <7580e821-bfa0-e4d4-435f-a042b0eba555@gmail.com>
 <1534841913.25523.0.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1534841913.25523.0.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 21, 2018 at 10:58:33AM +0200, Johannes Berg wrote:
> On Tue, 2018-08-21 at 10:57 +0200, Grzegorz Duszyński wrote:
> > I've just briefly tested it, looks like it's working!
> > I have only remote access to my machine at the moment so it's difficult 
> > to say for sure if everything is in order.
> > However stalls do not occur, nor there are any error/warnings anywhere.
> > 
> That probably just means you now have some invalid data somewhere,
> rather than a crash... Not sure which is better - I guess you'd rather
> have it not crash, and I'd rather figure out where the invalid data is
> coming from :)

I think corruption of ieee80211_wmm_rule could came from strange
pointers aritmetic and fwdb_wmm_rule can be fine. Anyway perhaps
something like this on top of RFC patch would be helpful. 

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index eb78c34d2357..4f84a67a0959 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -853,6 +853,11 @@ static void set_wmm_rule(struct ieee80211_reg_rule *rrule,
 	struct ieee80211_wmm_rule *rule = &rrule->wmm_rule;
 	unsigned int i;
 
+	if (!valid_wmm(wmm)) {
+		pr_err("Invalid WMM rule\n");
+		return;
+	}
+
 	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
 		rule->client[i].cw_min =
 			ecw2cw((wmm->client[i].ecw & 0xf0) >> 4);
