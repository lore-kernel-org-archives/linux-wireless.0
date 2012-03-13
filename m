Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:31495 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538Ab2CMEgI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Mar 2012 00:36:08 -0400
Message-ID: <4F5ECEB2.7050903@qca.qualcomm.com> (sfid-20120313_053615_776238_830204F2)
Date: Tue, 13 Mar 2012 10:06:02 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
CC: Felix Fietkau <nbd@openwrt.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	<ath9k-devel@lists.ath9k.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] [RFC] ath9k_hw: Fix chip revision checks
References: <1331531853-5043-1-git-send-email-mohammed@qca.qualcomm.com> <4F5DBB8B.1070000@openwrt.org> <4F5DBED4.4050500@qca.qualcomm.com> <20120312201650.GG26059@tux>
In-Reply-To: <20120312201650.GG26059@tux>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis,

On Tuesday 13 March 2012 01:46 AM, Luis R. Rodriguez wrote:
> On Mon, Mar 12, 2012 at 02:46:04PM +0530, Mohammed Shafi Shajakhan wrote:
>> Hi Felix,
>>
>> On Monday 12 March 2012 02:32 PM, Felix Fietkau wrote:
>>> On 2012-03-12 6:57 AM, Mohammed Shafi Shajakhan wrote:
>>>> From: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
>>>>
>>>> not sure if these checks are previously avoided may be those revision of
>>>> chipsets are obselete ?
>>> NACK. The extra checks that this patch adds have been intentionally
>>> removed, since all earlier versions were never sold and thus do not need
>>> to be considered. This simplifies the generated binary code.
>>
>> IMHO i don't think this patch does anything wrong to deserve a NACK!
>> sometimes these optimizations make it tad difficult if we want to
>> quickly check with the HAL code.
>
> "HAL" code from internal codebases need to change, not the other
> way around. You have your priorities wrong. I support the NACK.
>

we have checks like this

case 1.#define AR_SREV_9280_20_OR_LATER(_ah) \
	(((_ah)->hw_version.macVersion >= AR_SREV_VERSION_9280))

case 2. #define AR_SREV_9485_OR_LATER(_ah) \
	(((_ah)->hw_version.macVersion >= AR_SREV_VERSION_9485))


case 3. #define AR_SREV_9287_13_OR_LATER(_ah) \
	(((_ah)->hw_version.macVersion > AR_SREV_VERSION_9287) || \
	 (((_ah)->hw_version.macVersion == AR_SREV_VERSION_9287) && \
	  ((_ah)->hw_version.macRev >= AR_SREV_REVISION_9287_13)))

it made be bit confused and i was just adding some hardware related 
changes, let me do accept i missed to see why the check for AR9280 is 
like that. i just thought of making the changes in sync with the other 
macros, also thats why sent an RFC too

Felix suggested a better solution would be

#define AR_SREV_9280_OR_LATER(_ah) \
	(((_ah)->hw_version.macVersion >= AR_SREV_VERSION_9280))

instead of the older one (or) what my patch does

#define AR_SREV_9280_20_OR_LATER(_ah) \
	(((_ah)->hw_version.macVersion >= AR_SREV_VERSION_9280))

and make corresponding changes in the hardware code.

thanks!


-- 
thanks,
shafi
