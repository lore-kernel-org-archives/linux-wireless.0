Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f211.google.com ([209.85.219.211]:59548 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbZI2JGz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2009 05:06:55 -0400
Received: by ewy7 with SMTP id 7so5205029ewy.17
        for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2009 02:06:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200909291058.43765.malte.gell@gmx.de>
References: <999306.93095.qm@web23102.mail.ird.yahoo.com>
	 <200909291058.43765.malte.gell@gmx.de>
Date: Tue, 29 Sep 2009 10:06:58 +0100
Message-ID: <3ace41890909290206g3019a9cbv29048837804f830@mail.gmail.com>
Subject: Re: compat-wireless tracepoint error Re: [Ndiswrapper-general] Need
	help to create driver for Netgear WN111v2
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Malte Gell <malte.gell@gmx.de>
Cc: Hin-Tak Leung <hintak_leung@yahoo.co.uk>,
	ndiswrapper-general@lists.sourceforge.net,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 29, 2009 at 9:58 AM, Malte Gell <malte.gell@gmx.de> wrote:
>
> "Hin-Tak Leung" <hintak_leung@yahoo.co.uk> wrote
>
>> Hmm, I see you have already posted to linux-wireless and already got your
>>  answers. Hauke has already given you the answer - your kernel tree is
>>  *not* 2.6.27(.0), and as it is obvious that you have 2.6.27.29-0.1, which
>>  is 2.6.27.29 + suse-patches. Even 2.6.27.29 is not 2.6.27(.0), but
>>  somewhat closer to 2.6.28. And you really have already had your answer -
>>  your tree is somewhat between 2.6.27 and 2.6.28, and *neither*.
>>
>> My suggestion would be simply to delete all the 'error: redefinition' parts
>>  from net/compat-2.6.28.h , because you already have them in the suse tree.
>
> Thanx for your efforts. By the way, do I need to set  CONFIG_TRACEPOINTS in the
> kernel? I just see it is _not_ set in openSUSE 11.1.

No, do *not* modify any kernel config files. You should not do that,
as the compat modules should be compiled against a correct config, as
in a config that corresponds to how your kernel was built.

>>  You may also need to delete something from net/compat-2.6.28.c, but that
>>  will happen during the linking stage (much later).
>
> So, no need to modify compat-2.6.28.c? Does it automatically happen?

You may or may not  see any errors at the linker stage (the LD part in
stage 2). If you get to that point without further error, then, well,
count yourself lucky and just give "make install ; make unload;
modprobe -v ar9170" a go.
