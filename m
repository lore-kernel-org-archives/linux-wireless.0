Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from forward3j.cmail.yandex.net ([5.255.227.21]:39309 "EHLO
        forward3j.cmail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1757363AbcHYL0w (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Aug 2016 07:26:52 -0400
Subject: rtl8192ce
References: <321381b3-5dea-f16a-56cb-11120d4a38ef@yandex.ru>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>
Cc: linux-wireless@vger.kernel.org
From: Lobachevskii Vitalii <silverunicorn2011@yandex.ru>
Message-ID: <72b958e1-0200-cd6f-2012-e04ff6fb74cb@yandex.ru> (sfid-20160825_132717_693025_B2227D56)
Date: Thu, 25 Aug 2016 14:23:12 +0300
MIME-Version: 1.0
In-Reply-To: <321381b3-5dea-f16a-56cb-11120d4a38ef@yandex.ru>
Content-Type: multipart/mixed;
 boundary="------------960417583D6938E647FDB9A6"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------960417583D6938E647FDB9A6
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello,

The RTL8192CE device seems to work fine without any firmware, so you may
make it fully optional, removing dependency on FW_LOADER. Of course that
require some patching, but if I understood the driver internals
correctly, simple complete(&rtlpriv->firmware_loading_complete); would
be enough when firmware loading machinery is unavailable, that is, when
request_firmware_nowait returns -EINVAL (currently that may only happen
in improperly configured or patched kernels, like Linux-libre; see
attached messages for more information)

Of course I will try to fix Linux-libre =E2=80=9Cdeblobbing=E2=80=9D tech=
nique, as it
should never break anything that may work without a firmware. But
anyway, if a device and its driver may work without a certain kernel
feature, that feature should not be selected, I think.

Lobachevskii Vitalii


--------------960417583D6938E647FDB9A6
Content-Type: message/rfc822;
 name="Attached Message"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename="Attached Message"

Received: from fastsrv.yandex.ru ([84.201.187.240])
	by mxback8h.mail.yandex.net with LMTP id UFfnnq42XGk1
	for <silverunicorn2011@yandex.ru>; Sun, 14 Aug 2016 01:15:30 +0300
X-Yandex-Uniq: 124cf733-eade-4ab2-a34c-1aa1cd76be98
To: linux-libre@fsfla.org
From: number Zero <silverunicorn2011@yandex.ru>
Subject: Inaccurate deblobbing breaks rtl8192ce
Message-ID: <321381b3-5dea-f16a-56cb-11120d4a38ef@yandex.ru>
Date: Sun, 14 Aug 2016 01:16:48 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101
 Icedove/45.1.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

The rtl8192ce driver as present in linux-libre don’t work for me at all.
However, after I made it to ignore the EINVAL error from the
reject_firmware_nowait function (in
drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.c), it works fine.
I could send you the patch, but don’t think that’s the right solution.
Really, are there any reasons for reject_firmware_nowait to return
-EINVAL? Original function, request_firmware_nowait, returns non-zero
only in extreme conditions, like out-of-memory or module being unloaded.
Unlike request_firmware, it doesn’t fail when firmware is absent. So
shouldn’t the reject_firmware_nowait function behave as if the requested
firmware merely absent?


--------------960417583D6938E647FDB9A6
Content-Type: message/rfc822;
 name="Attached Message"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="Attached Message"

Received: from mxfront5h.mail.yandex.net ([127.0.0.1])
	by mxfront5h.mail.yandex.net with LMTP id jTMqxza4
	for <silverunicorn2011@yandex.ru>; Thu, 18 Aug 2016 22:14:26 +0300
Received: from linux-libre.fsfla.org (linux-libre.fsfla.org [208.118.235.54])
	by mxfront5h.mail.yandex.net (nwsmtp/Yandex) with ESMTPS id K9FoJjjWki-EPGq8KKQ;
	Thu, 18 Aug 2016 22:14:25 +0300
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(Client certificate not present)
Return-Path: lxoliva@fsfla.org
Received: from freie.home (home.lxoliva.fsfla.org [172.31.160.22])
	by linux-libre.fsfla.org (8.14.4/8.14.4/Debian-4.1ubuntu1) with ESMTP id u7IJEIDu021008;
	Thu, 18 Aug 2016 19:14:19 GMT
Received: from livre.home (livre.home [172.31.160.2])
	by freie.home (8.15.2/8.15.2) with ESMTP id u7IJE1o3024623;
	Thu, 18 Aug 2016 16:14:01 -0300
From: Alexandre Oliva <lxoliva@fsfla.org>
To: number Zero <silverunicorn2011@yandex.ru>
Cc: linux-libre@fsfla.org
Subject: Re: Inaccurate deblobbing breaks rtl8192ce
Organization: Free thinker, not speaking for FSF Latin America
References: <321381b3-5dea-f16a-56cb-11120d4a38ef@yandex.ru>
Errors-To: aoliva@lxoliva.fsfla.org
Date: Thu, 18 Aug 2016 16:14:01 -0300
In-Reply-To: <321381b3-5dea-f16a-56cb-11120d4a38ef@yandex.ru> (number Zero's
	message of "Sun, 14 Aug 2016 01:16:48 +0300")
Message-ID: <ortwehao06.fsf@livre.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Yandex-Forward: 1a71aadb444e5aa7f049850513799f43

Hi,

Thanks for your report!

On Aug 13, 2016, number Zero <silverunicorn2011@yandex.ru> wrote:

> However, after I made it to ignore the EINVAL error from the
> reject_firmware_nowait function (in
> drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.c), it works fine.

Interesting.  Can you check that this remains true even after a full
power cycle, as in, that it's not a blob loaded by a previous blobbed
kernel that remains it to work in your setting?  (if you never had the
blob around, or never used a blobbed kernel, just say so, and I'll be
happy enough about the conclusion ;-)

> Really, are there any reasons for reject_firmware_nowait to return
> -EINVAL?

Yes.  It the error code to indicate to the caller that the firmware
loading functionality is not avaialble.  It indicates the callback
supplied by the caller will not be called, so the caller itself should
take care of e.g. returning any temporary memory the callback would have
released.

If the driver works even if request_firmware_nowait returns such an
error, then it ought to tolerate this return code.

> So shouldn=E2=80=99t the reject_firmware_nowait function behave as if the
> requested firmware merely absent?

Given the multiple cases in which drivers were "surprised" by this
return code, I guess we could try to rework reject_firmware_nowait so as
to actually call the callback, signalling the unsuccessful completion of
the request.  Would you like to give that a try?

Or perhaps you'd prefer to report the bug to the rtl8192ce maintainers,
so that they could fix their driver so as to work (as it should) even
when the firmware loading configuration option is disabled?

Thanks,

--=20
Alexandre Oliva, freedom fighter    http://FSFLA.org/~lxoliva/
You must be the change you wish to see in the world. -- Gandhi
Be Free! -- http://FSFLA.org/   FSF Latin America board member
Free Software Evangelist|Red Hat Brasil GNU Toolchain Engineer

--------------960417583D6938E647FDB9A6--
