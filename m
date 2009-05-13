Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.189]:34896 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732AbZEMD4m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2009 23:56:42 -0400
Received: by fk-out-0910.google.com with SMTP id 18so193571fkq.5
        for <linux-wireless@vger.kernel.org>; Tue, 12 May 2009 20:56:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3ace41890905121400g471d14bfn3f60fba77e097079@mail.gmail.com>
References: <1242125077.4331.0.camel@johannes.local>
	 <3ace41890905121205v76d6b61cg94d0bbe55c04da7e@mail.gmail.com>
	 <3ace41890905121208s2029db39p730b2e174cd4b1e6@mail.gmail.com>
	 <1242156469.14227.7.camel@johannes.local>
	 <3ace41890905121259jeb504d7v78fe8f062fca7d21@mail.gmail.com>
	 <3ace41890905121400g471d14bfn3f60fba77e097079@mail.gmail.com>
Date: Wed, 13 May 2009 04:56:41 +0100
Message-ID: <3ace41890905122056v2070d1actdc17f45cc1a3a693@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: fix a couple of bugs with key ioctls
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hiya, I stuck in a few printk(KERN_DEBUG __LINE__) around the new
-EINVAL's and tried to see why setting things by iwconfig manually
works, but NM/wpa_supplicant does not,  and here is what I found.
Around line 600 of net/wireless/wext-compat.c (this is the hackish mod
version):
------------------------------------------
int cfg80211_wext_siwencodeext(struct net_device *dev,
	                       struct iw_request_info *info,
                               struct iw_point *erq, char *extra)

        switch (ext->alg) {

        case IW_ENCODE_ALG_WEP:
                if (erq->length == 5)
                        cipher = WLAN_CIPHER_SUITE_WEP40;
                else if (erq->length == 13)
			cipher = WLAN_CIPHER_SUITE_WEP104;
                else {
                  printk(KERN_DEBUG "line %d %d\n", __LINE__, erq->length);
                        cipher = WLAN_CIPHER_SUITE_WEP104;
                        /* return -EINVAL; */
                 }
                break;
        }
------------------------------------------------
For some unknown reason, when run with NM/wpa_supplicant with the same
authentication credentials to the same AP, erq->length is 53 instead
of 13. If I just modify it as above instead of returning EINVAL, then
I get to authenticate, etc. in the old mac80211 ioctls, the decision
of cipher is postponed a lot later, after playing with the default key
a bit?

Anyway, I think 53 is either 40+13 or 13 *4 +1, so is it a case of
wpa_supplicant putting more stuff at the end or an offset somewhere?
