Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:56851 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536Ab2GSLI6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jul 2012 07:08:58 -0400
Message-ID: <5007EABC.5050905@qca.qualcomm.com> (sfid-20120719_130902_766504_3723D039)
Date: Thu, 19 Jul 2012 14:08:44 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: fix incorrect use of IEEE80211_NUM_BANDS
References: <20120712091311.9751.60082.stgit@localhost6.localdomain6> <20120712134855.53d23fef@mj>
In-Reply-To: <20120712134855.53d23fef@mj>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Pavel,

sorry for the late reply, this got accidentally buried inside my todo
folder.

On 07/12/2012 08:48 PM, Pavel Roskin wrote:
> On Thu, 12 Jul 2012 12:13:12 +0300
> Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> 
>> +	/* only check 2.4 and 5 GHz bands, skip the rest */
>> +	for (band = 0; band <= IEEE80211_BAND_5GHZ; band++) {
> 
> There is something inelegant here.  The code is mixing an integer and
> an enum.  I'd rather go with one or those:
> 
> two enums:
> for (band = IEEE80211_BAND_2GHZ; band <= IEEE80211_BAND_5GHZ; band++) {

I somewhat see your point. But IMHO zero is commonly used when iterating
over an enum to denote the first value and I don't see how
IEEE80211_BAND_2GHZ helps here.

> or two integers:
> for (band = 0; band <= ATH6KL_NUM_BANDS; band++) {

ATH6KL_NUM_BANDS is also an enum so I don't see the difference.

Kalle
