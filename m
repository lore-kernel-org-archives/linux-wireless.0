Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55635 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933341Ab2FBRpm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jun 2012 13:45:42 -0400
Message-ID: <1338659135.12823.3.camel@jlt3.sipsolutions.net> (sfid-20120602_194546_516403_30F52500)
Subject: Re: [PATCH] ath9k: Fix a WARNING in suspend/resume with IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	ath9k-devel@lists.ath9k.org, stable@vger.kernel.org,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Date: Sat, 02 Jun 2012 19:45:35 +0200
In-Reply-To: <4FCA30DE.4080805@qca.qualcomm.com>
References: <1338532779-4621-1-git-send-email-mohammed@qca.qualcomm.com>
			 (sfid-20120601_083956_399882_A3D65832) <1338533070.4884.4.camel@jlt3.sipsolutions.net>
		 <4FC86AB4.9020602@qca.qualcomm.com>
	 <1338534832.4884.7.camel@jlt3.sipsolutions.net>
	 <4FCA30DE.4080805@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Mohammed,

> >>> You could just remove the entire check since the interface combinations
> >>> you advertise don't allow it, I think? Or just fix those
> >>> combinations :-)
> >>
> >> i did not check this before, thanks a lot for your inputs. will send a
> >> proper v2 after checking this out.
> >
> > If this is needed for stable, you might want to keep this patch&  send
> > another one to remove it.
> 
> thanks Johannes.
> i was looking at how to fix this properly in iface combination 
> advertised to mac80211.  got few doubts regarding this
> 
> *if an interface type is not all advertised in the 
> ieee80211_iface_combination then it cannot it be co-existing with any 
> other interfaces ?
> please let me know is there some other way do that.
> 
> if we advertise something like this
> 
> static const struct ieee80211_iface_limit if_limits[] = {
> 	{set1
>      	.... },
> 	{set 2
> 	.... },
> };
> 
> then interface types in set1 and set2 co-exist as per the logic in 
> cfg80211_can_change_interface. is there already a way we can make
> set1 and set2 interface types mutually exclusive ? thanks!

The sets are mutually exclusive, and there are implied sets of each
interface with a max number of 1. So for example, in iwlwifi we don't
advertise IBSS in the combinations at all, because it's not compatible
with anything. In your case, I think the same applies, since you said
        
        if the first interface is ADHOC we cannot have any other
        interface. we cannot add an ADHOC interface if there is already
        an interface is present

Thus, if you leave IBSS out of the combinations you should get the
desired behaviour of not being able to combine IBSS with any other
types.

johannes

