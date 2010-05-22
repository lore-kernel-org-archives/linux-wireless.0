Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f185.google.com ([209.85.222.185]:34082 "EHLO
	mail-pz0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935681Ab0EVBnN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 May 2010 21:43:13 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTinAydFcFSOK7D7T7_gQsghiYwW1bp4DNloyTAcJ@mail.gmail.com>
References: <1274489059-1019-1-git-send-email-lrodriguez@atheros.com>
	<AANLkTinAydFcFSOK7D7T7_gQsghiYwW1bp4DNloyTAcJ@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 21 May 2010 18:42:52 -0700
Message-ID: <AANLkTinVUu-N4EFu4S5I0bKM1sl9UrHXLufv_BL7KpgN@mail.gmail.com>
Subject: Re: [PATCH] compat-wireless: add linux-next-pending, crap patch dirs
	and nagometer
To: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 21, 2010 at 6:28 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Fri, May 21, 2010 at 5:44 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
>> Sometimes you have no other option but to carry around patches.
>> This can happen for a variety of reasons. Ultimately testing of code
>> cannot happen on the kernel maintainer's clock but on your own.
>>
>> This expands the idea of the linux-next-cherry-pick patch directory
>> on compat-wireless to also allow for patches to be merged which are
>> posted to some mailing list but pending merge due to some reasons
>> (merge window is a good example). It also adds a crap patch directory
>> for those really nasty situations you can run into where you have
>> no other option but to give someone a release with some delta even
>> if the patch is not yet posted anywhere.
>>
>> The focus should always be upstream though so to avoid these
>> situations we will also provide code metrics to indicate to
>> the package maintainer how much code came from each directory,
>> including the backport code to support older kernel releases.
>>
>> Maybe we should add the code-metrics.txt file as a print out
>> on the compat module load :)
>>
>> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>
> So this is what I get with what I just merged and using -p -c
>
> compat-wireless code metrics
>
>    497275 - Total upstream code being pulled
>      1393 - backport code changes
>      1163 - backport code additions
>       230 - backport code deletions
>      0.28 - % of code consists of backport work

I just realized this % is wrong as it only accounts for the *.patch
files for the backport. We'll have to exlude compat/ dir for the code
calculations and add the code there for the backport calculation.

  Luis
