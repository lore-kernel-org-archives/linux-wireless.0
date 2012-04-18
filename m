Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:50214 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386Ab2DRUTG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 16:19:06 -0400
Message-ID: <4F8F21B7.70809@openwrt.org> (sfid-20120418_221911_513114_0142260B)
Date: Wed, 18 Apr 2012 22:19:03 +0200
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Subject: Re: [RFC] ath9k: fix TX power reporting on AR9003 chips
References: <1334740589-7853-1-git-send-email-juhosg@openwrt.org> <4F8F1B5F.7050603@openwrt.org>
In-Reply-To: <4F8F1B5F.7050603@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012.04.18. 21:51 keltezéssel, Felix Fietkau írta:
> On 2012-04-18 11:16 AM, Gabor Juhos wrote:
>> The current code unconditionally reads the target
>> power values for all modes from the EEPROM. However
>> In 'ar9003_hw_set_power_per_rate_table' the regulatory
>> caps are applied only on a mode specific subset of the
>> power values.
>>
>> The reported TX power level is calculated from the
>> maximum of the power values. Because some of these
>> values are uncapped in certain cases, the reported
>> TX power will be wrong.
>>
>> On the older chipset, we don't have such problems
>> because only the mode specific subset of the power
>> levels are retrieved from the EEPROM on those. Do
>> the same for the AR9003 chips to fix the issue.
>>
>> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
> Acked-by: Felix Fietkau <nbd@openwrt.org>

Thanks!

-Gabor


