Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59623 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757538Ab1GASkB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jul 2011 14:40:01 -0400
Received: by yxi11 with SMTP id 11so1057969yxi.19
        for <linux-wireless@vger.kernel.org>; Fri, 01 Jul 2011 11:40:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E0B8E35.8080203@gnu.org>
References: <BANLkTimsGJo61eLp3NrVtDkh0m3CN3zDxw@mail.gmail.com>
	<4E0B8A61.8090600@upr.edu>
	<4E0B8E35.8080203@gnu.org>
Date: Fri, 1 Jul 2011 20:40:00 +0200
Message-ID: <BANLkTikEqPt1NkPr99Cfp_Rfp63z3s669Q@mail.gmail.com> (sfid-20110701_204006_265106_853FE4FB)
Subject: Re: Compile error in carl9170 on Debian Squeeze
From: Alex <alex9434@gmail.com>
To: Pavel Roskin <proski@gnu.org>
Cc: Omar Abraham <omar.abraham@upr.edu>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel, Omar and all,

thank you very much for your support. However, I still get the error message:

                 from <command-line>:0:
/usr/src/compat-wireless-2011-06-30/include/linux/compat-2.6.34.h:23:
error: redefinition of 'netdev_name'
/usr/src/linux-headers-2.6.32-5-common/include/linux/netdevice.h:2032:
error: previous definition of 'netdev_name' was here
make[5]: *** [/usr/src/compat-wireless-2011-06-30/compat/main.o] Error 1
make[4]: *** [/usr/src/compat-wireless-2011-06-30/compat] Error 2
make[3]: *** [_module_/usr/src/compat-wireless-2011-06-30] Error 2
make[2]: *** [sub-make] Error 2
make[1]: *** [all] Error 2
make[1]: Leaving directory `/usr/src/linux-headers-2.6.32-5-kirkwood'
make: *** [modules] Error 2
r
with the version from today.

BTW: One more question: There seems to be a module "carl9170" in the
2.6.39.2 kernel. Does this replace compat-wireless? Do I only need
this module to get the wlan in monitor mode? (please excuse my
question, I am really new to this...)

Greetings from Munich
-a

On Wed, Jun 29, 2011 at 10:42 PM, Pavel Roskin <proski@gnu.org> wrote:
> On 06/29/2011 04:26 PM, Omar Abraham wrote:
>>
>> You are using older kernel headers, most likely that could be the problem
>
> No, Debian backports netdev_name in 2.6.32.  The fix is to define
> netdev_name as a macro in compat-wireless.  The same issue was already
> reported today, and I'm about to send a patch.
>
> --
> Regards,
> Pavel Roskin
>
