Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:63439 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308Ab3GQCSt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jul 2013 22:18:49 -0400
Received: by mail-pa0-f41.google.com with SMTP id bj3so1428894pad.0
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jul 2013 19:18:49 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 00/53] wireless-regdb: latest updates
Date: Tue, 16 Jul 2013 19:17:49 -0700
Message-Id: <1374027522-18488-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20130717_041855_268827_D4F449A7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

I saw one comment posted about the Indonesia patch, I fixed that.
I also then ran some sanity tests with a new reglib addition
wich I recently posted. This helped find two cases which
required disabling VHT80 for two countries on a specific band.
One was for US for 5690 and another for TW for 5290. In both cases
the reason is due to the fact that the only way to use VHT80 is
to combine two frequency ranges together that are contiguous and
apply the most restrictive band rules for that range. We don't support
this yet so just disable VHT80 in both cases. In the US case this
also seems to be the preferred ruling.

This now goes out in patch form.

Luis R. Rodriguez (53):
  wireless-regdb: AU, Australia - enable VHT80
  wireless-regdb: BR, Brazil - enable VHT80
  wireless-regdb: CA, Canada - enable VHT80
  wireless-regdb: HK, Hong Kong - enable VHT80
  wireless-regdb: NZ, New Zealand - enable VHT80
  wireless-regdb: AR, Argentina - enable VHT80
  wireless-regdb: CO, Colombia - enable VHT80
  wireless-regdb: GU, Guam - enable VHT80
  wireless-regdb: MX, Mexico - enable VHT80
  wireless-regdb: PE, Peru - enable VHT80
  wireless-regdb: PH, Philippines - enable VHT80
  wireless-regdb: PR, Puerto Rico - enable VHT80
  wireless-regdb: SA, Saudi Arabia - enable VHT80
  wireless-regdb: SG, Singapore - enable VHT80
  wireless-regdb: ZA, South Africa - enable VHT80
  wireless-regdb: TH, Thailand - enable VHT80
  wireless-regdb: AE, United Arab Emirates - enable VHT80
  wireless-regdb: VN, Vietnam - enable VHT80
  wireless-regdb: AT, Austria - enable VHT80
  wireless-regdb: FR, France - enable VHT80
  wireless-regdb: DE, Germany - enable VHT80
  wireless-regdb: GB, United Kingdom - enable VHT80
  wireless-regdb: BE, Belgium - enable VHT80
  wireless-regdb: CZ, Czech Republic - enable VHT80
  wireless-regdb: DK, Denmark - enable VHT80
  wireless-regdb: FI, Finland - enable VHT80
  wireless-regdb: GR, Greece- enable VHT80
  wireless-regdb: IE, Ireland - enable VHT80
  wireless-regdb: IT, Italy - enable VHT80
  wireless-regdb: LU, Luxembourg - enable VHT80
  wireless-regdb: NL, Netherlands - enable VHT80
  wireless-regdb: PL, Poland - enable VHT80
  wireless-regdb: PT, Portugal - enable VHT80
  wireless-regdb: SK, Slovakia - enable VHT80
  wireless-regdb: ES, Spain - enable VHT80
  wireless-regdb: SE, Sweden - enable VHT80
  wireless-regdb: CH, Switzerland - enable VHT80
  wireless-regdb: TR, Turkey - enable VHT80
  wireless-regdb: CN, China - enable VHT80
  wireless-regdb: enable VHT80 and VHT160 for JP
  wireless-regdb: US, United States - enable VHT80
  wireless-regdb: ID, Indonesia - enable 5 GHz and VHT80
  wireless-regdb: IL, Isreal - enable VHT80
  wireless-regdb: KW, Kuwait - enable VHT80
  wireless-regdb: MY, Malaysia - enable VHT80
  wireless-regdb: MA, Morocco - enable 5 GHz and VHT80
  wireless-regdb: enable HT40 in RU - Russian Federation
  wireless-regdb: KR, Republic of Korea - enable VHT80
  wireless-regdb: TW, Taiwan - enable VHT80
  wireless-regdb: enable VHT80 when world roaming
  wireless-regdb: add 802.11ad 60 GHz channels 1..3 to world regdom
  wireless-regdb: CR, Costa Rica - enable VHT80
  wireless-regdb: EC, Ecauador - enable VHT80

 db.txt |  316 +++++++++++++++++++++++++++++++++++-----------------------------
 1 file changed, 173 insertions(+), 143 deletions(-)

-- 
1.7.10.4

