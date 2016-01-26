Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:50058 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964992AbcAZN5y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 08:57:54 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: pull request: iwlwifi 2016-01-26
Date: Tue, 26 Jan 2016 13:57:30 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32E9D570C@hasmsx109.ger.corp.intel.com> (sfid-20160126_145757_359075_F35650DF)
References: <0BA3FCBA62E2DC44AF3030971E174FB32E9D452F@hasmsx109.ger.corp.intel.com>
 <87h9i0qwjp.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

On 01/26/2016 03:51 PM, Kalle Valo wrote:
> "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com> writes:
>
>> This is the first round of fixes for 4.5. Most of them are really
>> trivial. The TPC stats one stands out a little bit. It can fix traffic
>> issues which are typically hard to debug. Please pull and let me know
>> if you have issues.
> There's a conflict due to 8f57e4d930d, how should I fix it?
>
> diff --cc drivers/net/wireless/intel/iwlwifi/dvm/calib.c
> index e9cef9de9ed8,14949efc4a35..000000000000
> --- a/drivers/net/wireless/intel/iwlwifi/dvm/calib.c
> +++ b/drivers/net/wireless/intel/iwlwifi/dvm/calib.c
> @@@ -900,8 -900,8 +900,13 @@@ static void iwlagn_gain_computation(str
>   
>                 /* bound gain by 2 bits value max, 3rd bit is sign */
>                 data->delta_gain_code[i] =
> ++<<<<<<< HEAD
>  +                      min(abs(delta_g),
>  +                      (s32) CHAIN_NOISE_MAX_DELTA_GAIN_CODE);
> ++=======
> +                       min_t(u8, abs(delta_g),
> +                             CHAIN_NOISE_MAX_DELTA_GAIN_CODE);
> ++>>>>>>> c3653efc57d9b3c51ee657a471578d2493b6e3f0
>   
>                 if (delta_g < 0)
>                         /*
>
No, I'll rebase.
thanks.

>> I also have a batch of patches for -next, but
>> wireless-drivers-next.git doesn't seem ready to accept new patches at
>> this stage.
> I'll open wireless-drivers-next once net-next is open, but AFAIK Dave
> hasn't opened it yet.
>

