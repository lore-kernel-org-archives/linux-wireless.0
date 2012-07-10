Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51620 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743Ab2GJALi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 20:11:38 -0400
Received: by yenl2 with SMTP id l2so10716136yen.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jul 2012 17:11:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6UF57isp+z4j3c0JNyTKHKfUsbU1UhMYKbZdGfEaeLn3w@mail.gmail.com>
References: <1341845663-24539-1-git-send-email-ozancag@gmail.com>
	<CAB=NE6UF57isp+z4j3c0JNyTKHKfUsbU1UhMYKbZdGfEaeLn3w@mail.gmail.com>
Date: Tue, 10 Jul 2012 03:11:37 +0300
Message-ID: <CAFub=KRj46WGkervvZxXB4nFQvPvu6yo_FvCXDGLPiuCyq8VNQ@mail.gmail.com> (sfid-20120710_021142_634414_A2042468)
Subject: Re: [RFC] compat: Add ability to run as non-root
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: linux-wireless@vger.kernel.org, mcgrof@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 10, 2012 at 2:50 AM, Luis R. Rodriguez <mcgrof@frijolero.org> wrote:
> On Mon, Jul 9, 2012 at 7:54 AM, Ozan Çağlayan <ozancag@gmail.com> wrote:
>> If the EUID of the process is not 0, assume that get-compat-kernels
>> is run as a regular user and extract the downloaded *.deb files
>> from debs/ into
>
>> ksrcs/:
>
> How about $HOME/ksrc/ ?
>
>> ksrcs/
>> ├── lib
>> │   └── modules
>> │       ├── 2.6.24-020624-generic
>> │       ├── 2.6.25-020625-generic
>> │       ├── ...
>> │       └── 3.4.4-030404-generic
>> └── usr
>>     └── src
>>         ├── linux-headers-2.6.24-020624
>>         ├── linux-headers-2.6.24-020624-generic
>>         ├── linux-headers-2.6.25-020625
>>         ├── linux-headers-2.6.25-020625-generic
>>         ├── ...
>>         ├── linux-headers-3.4.4-030404
>>         └── linux-headers-3.4.4-030404-generic
>
> Nice!
>
>> If you still want to use your kernel sources under /, run
>> get-compat-kernels
>
> Neat!
>
>> or ckmake with 'sudo'.
>
> How about instead having ckmake detect first if you have your
> $HOME/ksrc/ and if so use that, otherwise go with the built in stuff ?

You are right, that would be much better. Will rework and send a new patch.

Thanks :)


-- 
Ozan Çağlayan
