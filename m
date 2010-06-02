Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58689 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932449Ab0FBSBt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jun 2010 14:01:49 -0400
Received: by wyi11 with SMTP id 11so2094890wyi.19
        for <linux-wireless@vger.kernel.org>; Wed, 02 Jun 2010 11:01:47 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1275497610.32562.15.camel@maxim-laptop>
References: <1275395142.14385.6.camel@maxim-laptop>
	<1275404221.2839.2.camel@maxim-laptop>
	<AANLkTinmjlukRABwWWVuO6VRHrULcqB7Zk_HQZSDicKr@mail.gmail.com>
	<1275415929.3778.1.camel@maxim-laptop>
	<1275497610.32562.15.camel@maxim-laptop>
Date: Wed, 2 Jun 2010 20:01:46 +0200
Message-ID: <AANLkTik-IDbMY4K2AVCjd-qOEj3mwnFYeV6ODzUCiIBu@mail.gmail.com>
Subject: Re: IWL3945 problems in 2.6.35-rc1
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: wireless <linux-wireless@vger.kernel.org>,
	ipw3945-devel@lists.sourceforge.net, ilw@linux.intel.com
Content-Type: multipart/mixed; boundary=00163649a95328093004880fe24d
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--00163649a95328093004880fe24d
Content-Type: text/plain; charset=UTF-8

Hi Maxim,

I have tested here with the patches from wireless-2.6 plus this patch
in my series against 2.6.35-rc1:

# patch from <https://patchwork.kernel.org/patch/103133/>
linux-wireless/2.6.34-mac80211-fix-blockack-req-processing.patch

Unfortunately, I have here no open AP and I am not in a real test mood :-).

I could not test "mac80211: process station blockack action frames
from work" [1] yet.
It is Cc: stable@kernel.org.

All mentionned patches apply cleanly against vanilla 2.6.35-rc1 (see
below, patches attached as tarball).

- Sedat -

[1] https://patchwork.kernel.org/patch/102892/

[ patch-series ]

Applying patch wireless-2.6/0001-Revert-rt2x00-Fix-rt2800usb-TX-descriptor-writing.patch
patching file drivers/net/wireless/rt2x00/rt2800usb.c

Applying patch wireless-2.6/0002-ar9170usb-fix-read-from-freed-driver-context.patch
patching file drivers/net/wireless/ath/ar9170/usb.c

Applying patch wireless-2.6/0003-ath9k-Fix-ath_print-in-xmit-for-hardware-reset.patch
patching file drivers/net/wireless/ath/ath9k/xmit.c

Applying patch wireless-2.6/0004-ath9k-Fix-bug-in-the-way-bf_tx_aborted-of-struct-ath.patch
patching file drivers/net/wireless/ath/ath9k/xmit.c

Applying patch wireless-2.6/0005-libertas-fix-uninitialized-variable-warning.patch
patching file drivers/net/wireless/libertas/rx.c

Applying patch wireless-2.6/0006-mac80211-make-a-function-static.patch
patching file net/mac80211/chan.c

Applying patch wireless-2.6/0007-ssb-fix-NULL-ptr-deref-when-pcihost_wrapper-is-used.patch
patching file drivers/ssb/pci.c
patching file drivers/ssb/sprom.c

Applying patch iwlwifi-fix/iwl3945-Fix-internal-scan-races.patch
patching file drivers/net/wireless/iwlwifi/iwl3945-base.c
Hunk #1 succeeded at 1844 (offset 61 lines).
Hunk #2 succeeded at 3060 (offset 59 lines).

Applying patch linux-wireless/2.6.34-mac80211-fix-blockack-req-processing.patch
patching file net/mac80211/rx.c
Hunk #1 succeeded at 1818 (offset -1 lines).

Applying patch linux-wireless/mac80211-process-station-blockack-action-frames-from-work.patch
patching file net/mac80211/mlme.c
patching file net/mac80211/rx.c
Hunk #1 succeeded at 1944 (offset 8 lines).

--- EOT ---

On Wed, Jun 2, 2010 at 6:53 PM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> On Tue, 2010-06-01 at 21:12 +0300, Maxim Levitsky wrote:
>> On Tue, 2010-06-01 at 17:21 +0200, Sedat Dilek wrote:
>> > Hi Maxim,
>> >
>> > that's a known issue... and there were several mails to LKML and here
>> > on the ML (as I see you are very active on both lists :-)).
>> > Unfortunately, the patch in [1] didnt go into any (GIT) reposoitory. I know.
>> >
>> > I am attaching the original patch and give it a meaningfull name, so
>> > people see it on patchwork.kernel.org (linux-wireless).
>>
>> The patch appears the work, Thanks!
> And it still works.
>
>
>>
>> Now the only problem remains is that I can associate only when device is
>> in promisc mode.
>> I think it doesn't receive broadcast frames.
> Any update on this?
> This is going to be real show stopper for normal users.
> Its pretty much not possible to connect to open AP now unless promisc
> mode is enabled.
>
>
> Best regards,
> Maxim Levitsky
> |
>
>
>

--00163649a95328093004880fe24d
Content-Type: application/octet-stream; name="for_maxim.tar.xz"
Content-Disposition: attachment; filename="for_maxim.tar.xz"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g9ygn7l00

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
--00163649a95328093004880fe24d
Content-Type: application/octet-stream; name="for_maxim.tar.xz.sha256sum"
Content-Disposition: attachment; filename="for_maxim.tar.xz.sha256sum"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g9ygng0s1

NzIzNjdlNWY2OWRjZGMzZjQ1Mzk5NjY2ZjVlODg3NDQ1ZjUyOGNhMThkN2RkZWY1MjQ0YzI0Y2Yx
NGIwYmNiNyAgZm9yX21heGltLnRhci54ego=
--00163649a95328093004880fe24d--
