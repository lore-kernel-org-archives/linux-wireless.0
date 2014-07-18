Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f45.google.com ([209.85.219.45]:37092 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762498AbaGRP1E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2014 11:27:04 -0400
Received: by mail-oa0-f45.google.com with SMTP id i7so3465368oag.4
        for <linux-wireless@vger.kernel.org>; Fri, 18 Jul 2014 08:27:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140718014713.GA32594@kroah.com>
References: <1405373897-31671-1-git-send-email-keescook@chromium.org>
	<1405373897-31671-3-git-send-email-keescook@chromium.org>
	<20140718014713.GA32594@kroah.com>
Date: Fri, 18 Jul 2014 08:27:04 -0700
Message-ID: <CAGXu5jJA6dGyJud2hEMY=ToxKbCqcsJeXYDVjivrUdhO=eSHCA@mail.gmail.com> (sfid-20140718_172745_612696_F896BBAF)
Subject: Re: [PATCH 2/7] test: add firmware_class loader test
From: Kees Cook <keescook@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Ming Lei <ming.lei@canonical.com>,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	James Morris <james.l.morris@oracle.com>,
	David Howells <dhowells@redhat.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	linux-security-module <linux-security-module@vger.kernel.org>,
	linux-firmware@kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 17, 2014 at 6:47 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Mon, Jul 14, 2014 at 02:38:12PM -0700, Kees Cook wrote:
>> This provides a simple interface to trigger the firmware_class loader
>> to test built-in, filesystem, and user helper modes. Additionally adds
>> tests via the new interface to the selftests tree.
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>>  lib/Kconfig.debug                                 |   13 +++
>>  lib/Makefile                                      |    1 +
>>  lib/test_firmware.c                               |  117 +++++++++++++++++++++
>
> Side note, I find it odd that in-kernel test modules are in lib/.
>
> But whatever, you aren't the one that did this first, so I'm not going
> to object here, I'll apply this, nice work.

Yeah, with each new selftest, I become less and less happy with the
lack of an intentional layout and execution framework. I've been
pondering some ideas on cleaning it up, but I have nothing solid yet.

The main reason for things living lib/ is because of how the
Kconfig.debug stuff is layed out. I think separating the concept of
"debug" from "test" is needed, and then the selftests make targets
need to be sorted out so that there's some common reporting method of
success vs failure, and that failures don't abort the whole thing,
etc, etc.

-Kees

-- 
Kees Cook
Chrome OS Security
