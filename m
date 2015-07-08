Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:36037 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbbGHXsD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jul 2015 19:48:03 -0400
MIME-Version: 1.0
In-Reply-To: <559D29B9.2080408@users.sourceforge.net>
References: <alpine.DEB.2.10.1402251014170.2080@hadrien> <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net> <558EB32E.6090003@users.sourceforge.net>
 <558EB4DE.3080406@users.sourceforge.net> <20150707023103.GA22043@kroah.com>
 <559B6FF8.9010704@users.sourceforge.net> <CAH6sp9Nn7LKdqT9E0bykY8jpEc-Ugxn8wby5yLcW+nsx=yG3NQ@mail.gmail.com>
 <559B85CD.6040200@users.sourceforge.net> <CAH6sp9Npqma18pj=ZsxYpCNDCm-AjjXvw61MGKBEKSYvg_LUBg@mail.gmail.com>
 <559BBDD6.7040808@users.sourceforge.net> <CAH6sp9O=NgJXOJzQaaA0o_yae+ae1oJa5Kcqmpo-WWBO_xUW+g@mail.gmail.com>
 <559BFB19.2080700@users.sourceforge.net> <CAGRGNgXTN8AxBNNfie4KvvErOXm3LUyL_QLLWQ6TN_wJgJkD-A@mail.gmail.com>
 <559CCC9D.8050606@users.sourceforge.net> <CAGRGNgWcHxwjx07A45No8vArXR12JGKcfif1Rvi30PQbJs4SGQ@mail.gmail.com>
 <559CED4C.1080402@users.sourceforge.net> <CAGRGNgU1SSUw-97aS0nhFObcMpLPdP3ej9WWNVwN77Fd=ws-bQ@mail.gmail.com>
 <559D29B9.2080408@users.sourceforge.net>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 9 Jul 2015 09:47:43 +1000
Message-ID: <CAGRGNgU+1xsdXe9aTYCVvowbo-w9s7chcaNphzzdB2xsuXOBxA@mail.gmail.com> (sfid-20150709_014809_635876_8F08D485)
Subject: Re: Clarification for the use of additional fields in the message body
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Frans Klaver <fransklaver@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Chris Park <chris.park@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	Julia Lawall <julia.lawall@lip6.fr>,
	kernel-janitors@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Markus,

On Wed, Jul 8, 2015 at 11:46 PM, SF Markus Elfring
<elfring@users.sourceforge.net> wrote:
>> Is there truly no way to simplify that process?
>
> I see some software development possibilities which could improve
> the communication with high volume mailing lists.

You shouldn't need any software development, most people's processes are:

1. Make changes
2. git add <files>
3. git commit
4. Repeat 1-3 for all changes they want to make
5. git-format-patch
6. git-send-email through some SMTP server to the list and appropriate
other people

>From what I've read, you appear to have some semi-automatic tool for
steps 1 through 4. I'd strongly recommend changing your patch
submission process to use git-format-patch and git-send-email. If
Sourceforge's email system doesn't let you send emails with SMTP
directly, then you might want to try sending emails through your ISP's
mail server.

Maintainers use a very similar process, however they collect and
review patches in some personal repository in addition to making
changes and committing them. Tools like patchwork are simply fancy
methods of accumulating patches into git trees. Most people are using
git-format-patch and git-send-email, possibly with some scripting
around them, to format and send patches.

>> You should be sending the patches directly with SMTP using git-send-email,
>
> This tool is also fine for the publishing of a lot of patches.

git-send-email or some other tool?

>> if you're not, then you're making things overly complicated for yourself.
>
> But I prefer a graphical user interface for my mail handling so far.

I send my patches using git-send-email through gmail's servers then
deal with literally everything else through gmail's web interface or
Android app. Using git-send-email doesn't mean you can't use a
graphical mail interface.

I used to send patches through a carefully configured instance of
Thunderbird, however this required too many steps and it loved to
mangle patches in ways that annoyed people.

>> Having a feature doesn't mean that it should be used.
>
> Does any of the "questionable functionality" get occasionally overlooked
> a bit too often?

It's not "questionable functionality", it's functionality we don't see
a need for.

If I wanted to, I could insert a patch at any point in the history of
Linux in my own repository, however any attempt to push that upstream
would cause enormous amounts of pain and annoyance, to everyone who
attempted to deal with it, so I don't.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
