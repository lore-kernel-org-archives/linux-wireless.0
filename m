Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from icf.org.ru ([91.193.236.10]:38197 "EHLO icf.org.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099Ab3BPEgK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2013 23:36:10 -0500
Date: Sat, 16 Feb 2013 08:18:56 +0400 (MSK)
From: Georgiewskiy Yuriy <bottleman@icf.org.ru>
To: Adrian Chadd <adrian@freebsd.org>
cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	devel@lists.open80211s.org
Subject: Re: improve operational ANI in Mesh mode
In-Reply-To: <CAJ-Vmo=W5b_tsb1u-RXwzRqM=tA9=myvLSuZWyy3drSmSmda+g@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1302160815210.17887@icf.org.ru> (sfid-20130216_053619_336382_A014F142)
References: <alpine.DEB.2.02.1302160630580.4293@icf.org.ru> <CAJ-Vmo=W5b_tsb1u-RXwzRqM=tA9=myvLSuZWyy3drSmSmda+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1051000339-1461825341-1360988336=:17887"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1051000339-1461825341-1360988336=:17887
Content-Type: TEXT/PLAIN; charset=KOI8-R
Content-Transfer-Encoding: 8BIT

On 2013-02-15 20:08 -0800, Adrian Chadd wrote Georgiewskiy Yuriy:

it seems there is another one place related to this:

drivers/net/wireless/ath/ath9k/link.c in

void ath_ani_calibrate(unsigned long data)

short_cal_interval = (ah->opmode == NL80211_IFTYPE_AP) ? 

should be

short_cal_interval = (ah->opmode == NL80211_IFTYPE_AP || ah->opmode == NL80211_IFTYPE_MESH_POINT) ?

AC>I think this is correct.
AC>
AC>
AC>
AC>adrian
AC>
AC>
AC>On 15 February 2013 18:43, Georgiewskiy Yuriy <bottleman@icf.org.ru> wrote:
AC>>
AC>> Hi, in our setups we experience pure ANI operational in mesh mode
AC>> VS AP mode, after debuffing and digging in ANI code i find what ANI
AC>> in AP mode work in limited mode, i try this mode with mesh and seems
AC>> getting same good operation as in AP mode, i am not familiar with ANI
AC>> may be there is another better way to fix this issue?
AC>>
AC>> changes what i made:
AC>>
AC>> diff -ruN compat-drivers-3.7.6-1/drivers/net/wireless/ath/ath9k/ani.c
AC>> compat-drivers-3.7.6-1-new/drivers/net/wireless/ath/ath9k/ani.c
AC>> --- compat-drivers-3.7.6-1/drivers/net/wireless/ath/ath9k/ani.c 2013-02-11
AC>> 04:23:53.000000000 +0400
AC>> +++ compat-drivers-3.7.6-1-new/drivers/net/wireless/ath/ath9k/ani.c
AC>> 2013-02-16 05:03:46.640746411 +0400
AC>> @@ -303,7 +303,8 @@
AC>>         ah->stats.ast_ani_reset++;
AC>>
AC>>         /* only allow a subset of functions in AP mode */
AC>> -       if (ah->opmode == NL80211_IFTYPE_AP) {
AC>> +       if (ah->opmode == NL80211_IFTYPE_AP || ah->opmode ==
AC>> NL80211_IFTYPE_MESH_POINT) {
AC>> +               ath_dbg(common, ANI, "only allow a subset of functions in AP
AC>> or MESH mode");
AC>>                 if (IS_CHAN_2GHZ(chan)) {
AC>>                         ah->ani_function = (ATH9K_ANI_SPUR_IMMUNITY_LEVEL |
AC>>                                             ATH9K_ANI_FIRSTEP_LEVEL);
AC>> @@ -323,7 +324,8 @@
AC>>
AC>>         if (is_scanning ||
AC>>             (ah->opmode != NL80211_IFTYPE_STATION &&
AC>> -            ah->opmode != NL80211_IFTYPE_ADHOC)) {
AC>> +            ah->opmode != NL80211_IFTYPE_ADHOC && +         ah->opmode !=
AC>> NL80211_IFTYPE_MESH_POINT)) {
AC>>                 /*
AC>>                  * If we're scanning or in AP mode, the defaults (ini)
AC>>                  * should be in place. For an AP we assume the historical
AC>>
AC>>
AC>>
AC>> C уважением                       With Best Regards
AC>> Георгиевский Юрий.                Georgiewskiy Yuriy
AC>> +7 4872 711666                    +7 4872 711666
AC>> факс +7 4872 711143               fax +7 4872 711143
AC>> Компания ООО "Ай Ти Сервис"       IT Service Ltd
AC>> http://nkoort.ru                  http://nkoort.ru
AC>> JID: GHhost@icf.org.ru            JID: GHhost@icf.org.ru
AC>> YG129-RIPE                        YG129-RIPE
AC>

C уважением                       With Best Regards
Георгиевский Юрий.                Georgiewskiy Yuriy
+7 4872 711666                    +7 4872 711666
факс +7 4872 711143               fax +7 4872 711143
Компания ООО "Ай Ти Сервис"       IT Service Ltd
http://nkoort.ru                  http://nkoort.ru
JID: GHhost@icf.org.ru            JID: GHhost@icf.org.ru
YG129-RIPE                        YG129-RIPE
---1051000339-1461825341-1360988336=:17887--
