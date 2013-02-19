Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from icf.org.ru ([91.193.237.1]:34442 "EHLO icf.org.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932906Ab3BSOgb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Feb 2013 09:36:31 -0500
Date: Tue, 19 Feb 2013 18:04:30 +0400 (MSK)
From: Georgiewskiy Yuriy <bottleman@icf.org.ru>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	devel@lists.open80211s.org
Subject: Re: improve operational ANI in Mesh mode
In-Reply-To: <20130219134028.GA26332@pandem0nium>
Message-ID: <alpine.DEB.2.02.1302191752110.31254@icf.org.ru> (sfid-20130219_153636_489946_538AAD6B)
References: <alpine.DEB.2.02.1302160630580.4293@icf.org.ru> <20130219134028.GA26332@pandem0nium>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1051000339-399364082-1361282670=:31254"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1051000339-399364082-1361282670=:31254
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On 2013-02-19 14:40 +0100, Simon Wunderlich wrote Georgiewskiy Yuriy:

Hi, i don't know mutch about ibss mode, but in 802.11s we expirience massive 
packetloss sometime, also according to signal levels ani seems not work at all,
it adjust some level while interface startup, then it stay forether, levels 
varies about from -10 to -60db dBm, for example - rmmod then insmod, bring interface 
up - see one level, rmmod then insmod, bring interface up - another level, 
and so on, also seems issuing scan make some level ajust, in random side too. 
but as i say before - i dont familiar with ani, i just make it work in 802.11s 
mode as in AP mode and this helps. you can try of cose my patch, just change 
NL80211_IFTYPE_MESH_POINT to NL80211_IFTYPE_ADHOC, but i don't known make it 
sence or not.

SW>Hello Georgiewskiy,
SW>
SW>On Sat, Feb 16, 2013 at 06:43:16AM +0400, Georgiewskiy Yuriy wrote:
SW>> 
SW>> Hi, in our setups we experience pure ANI operational in mesh mode
SW>> VS AP mode, after debuffing and digging in ANI code i find what ANI
SW>> in AP mode work in limited mode, i try this mode with mesh and seems
SW>> getting same good operation as in AP mode, i am not familiar with ANI
SW>> may be there is another better way to fix this issue?
SW>
SW>We sometimes see some problems too where we suspect ANI, but we are not
SW>and it's hard to reproduce. Our mesh networks are IBSS mode based, not
SW>802.11s mesh, so I wonder if we can apply your findings to IBSS mode too.
SW>
SW>Can you describe how your setup looks like, and what difference your patches
SW>make? Did you experience some problem which was easily reproducable?
SW>Also, do you plan to send a proper patch?
SW>
SW>Thanks,
SW>	Simon
SW>
SW>> 
SW>> changes what i made:
SW>> 
SW>> diff -ruN compat-drivers-3.7.6-1/drivers/net/wireless/ath/ath9k/ani.c compat-drivers-3.7.6-1-new/drivers/net/wireless/ath/ath9k/ani.c
SW>> --- compat-drivers-3.7.6-1/drivers/net/wireless/ath/ath9k/ani.c	2013-02-11 04:23:53.000000000 +0400
SW>> +++ compat-drivers-3.7.6-1-new/drivers/net/wireless/ath/ath9k/ani.c	2013-02-16 05:03:46.640746411 +0400
SW>> @@ -303,7 +303,8 @@
SW>>  	ah->stats.ast_ani_reset++;
SW>> 
SW>>  	/* only allow a subset of functions in AP mode */
SW>> -	if (ah->opmode == NL80211_IFTYPE_AP) {
SW>> +	if (ah->opmode == NL80211_IFTYPE_AP || ah->opmode == NL80211_IFTYPE_MESH_POINT) {
SW>> +		ath_dbg(common, ANI, "only allow a subset of functions in AP or MESH mode");
SW>>  		if (IS_CHAN_2GHZ(chan)) {
SW>>  			ah->ani_function = (ATH9K_ANI_SPUR_IMMUNITY_LEVEL |
SW>>  					    ATH9K_ANI_FIRSTEP_LEVEL);
SW>> @@ -323,7 +324,8 @@
SW>> 
SW>>  	if (is_scanning ||
SW>>  	    (ah->opmode != NL80211_IFTYPE_STATION &&
SW>> -	     ah->opmode != NL80211_IFTYPE_ADHOC)) {
SW>> +	     ah->opmode != NL80211_IFTYPE_ADHOC && +	     ah->opmode !=
SW>> NL80211_IFTYPE_MESH_POINT)) {
SW>>  		/*
SW>>  		 * If we're scanning or in AP mode, the defaults (ini)
SW>>  		 * should be in place. For an AP we assume the historical
SW>> 
SW>> 
SW>> 
SW>> C уважением                       With Best Regards
SW>> Георгиевский Юрий.                Georgiewskiy Yuriy
SW>> +7 4872 711666                    +7 4872 711666
SW>> факс +7 4872 711143               fax +7 4872 711143
SW>> Компания ООО "Ай Ти Сервис"       IT Service Ltd
SW>> http://nkoort.ru                  http://nkoort.ru
SW>> JID: GHhost@icf.org.ru            JID: GHhost@icf.org.ru
SW>> YG129-RIPE                        YG129-RIPE
SW>
SW>

C уважением                       With Best Regards
Георгиевский Юрий.                Georgiewskiy Yuriy
+7 4872 711666                    +7 4872 711666
факс +7 4872 711143               fax +7 4872 711143
Компания ООО "Ай Ти Сервис"       IT Service Ltd
http://nkoort.ru                  http://nkoort.ru
JID: GHhost@icf.org.ru            JID: GHhost@icf.org.ru
YG129-RIPE                        YG129-RIPE
---1051000339-399364082-1361282670=:31254--
