Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f183.google.com ([209.85.211.183]:43284 "EHLO
	mail-yw0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275AbZHFQ5L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2009 12:57:11 -0400
Received: by ywh13 with SMTP id 13so1236243ywh.15
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2009 09:57:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1249576886.14919.16.camel@mj>
References: <4A7A8F7E.6020503@redfish-solutions.com> <1249569993.6446.2.camel@jdl-desktop>
	<1249576886.14919.16.camel@mj>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 6 Aug 2009 09:56:51 -0700
Message-ID: <43e72e890908060956j3548c23ak4cf98d11c32efec0@mail.gmail.com>
Subject: Re: CRDA and cross-compilation
To: Pavel Roskin <proski@gnu.org>
Cc: Jon Loeliger <jdl@bigfootnetworks.com>,
	"Philip A. Prindeville" <philipp_subx@redfish-solutions.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 6, 2009 at 9:41 AM, Pavel Roskin<proski@gnu.org> wrote:
> On Thu, 2009-08-06 at 09:46 -0500, Jon Loeliger wrote:
>> On Thu, 2009-08-06 at 01:08 -0700, Philip A. Prindeville wrote:
>> > Who currently owns CRDA?
>> >
>> > I started to stare at cross-compiling issues, but realized that we need
>> > two versions of reglib.o and print-regdom.o...
>> >
>> > One to link with regdumpdb (compiled with HOSTCC) and one to link with
>> > everything else (compiled with TARGET_CC)...
>> >
>> > No easy way to do this without a lot of changes.
>>
>> I posted a 5-part patch series to address this issue.
>> To the best of my knowledge, it has not been applied yet.
>>
>> You can find it here:
>>
>> http://article.gmane.org/gmane.linux.kernel.wireless.general/35350
>
> I objected against using the misleading use of the "TARGET" work in some
> variables, but there was no reaction.  Failure to react to objections is
> the likely reason it wasn't applied.

Indeed.

> I also think that you add too much complexity to the Makefile.

Agreed.

> Also, the use of .config is not common.  Most valuables can be specified
> on the command line.  That would override the definitions in Makefile,
> and that's how it's done.

Yeah for something so simple as CRDA it seems overkill to have a .config.

> For instance, you can have this in Makefile:
>
> HOSTCC = gcc
> CC = $(HOSTCC)
>
> Running "make CC=/opt/mips/bin/gcc" would override CC but not HOSTCC.

ACK, is it possible to make it simpler?

  Luis
