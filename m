Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.181]:12787 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbYKLBIn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2008 20:08:43 -0500
Received: by el-out-1112.google.com with SMTP id z25so114856ele.1
        for <linux-wireless@vger.kernel.org>; Tue, 11 Nov 2008 17:08:41 -0800 (PST)
Message-ID: <43e72e890811111702x7b817c4bpdeed5acf39b2a5fd@mail.gmail.com> (sfid-20081112_020851_688671_5007ADEB)
Date: Tue, 11 Nov 2008 17:02:34 -0800
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Hin-Tak Leung" <htl10@users.sourceforge.net>
Subject: Re: a couple of small bugs in compat-wireless -- libertas
Cc: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>,
	"compat-masters@lists.madwifi.org" <compat-masters@lists.madwifi.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	dwmw2@infradead.org, dcbw@redhat.com, linville@tuxdriver.com,
	tim.gardner@canonical.com
In-Reply-To: <20081112005420.GQ14202@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <252423.50522.qm@web23105.mail.ird.yahoo.com>
	 <20081111231233.GK14202@tesla> <20081112005420.GQ14202@tesla>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 11, 2008 at 4:54 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Tue, Nov 11, 2008 at 03:12:33PM -0800, Luis Rodriguez wrote:
>> On Mon, Nov 10, 2008 at 09:28:59PM -0800, Hin-Tak Leung wrote:
>> > "make unload" doesn't unload iwlagn, and iwlagn keeps mac80211 in the kernel, which results in make unload failing. Needs to include iwlagn
>> > in the unload list in script/unload.sh. Should be trivial to fix, and
>> > probably quicker "just do it" then having a patch from me :-).
>> >
>> > There is another annoyance - probably not strictly speaking a bug, but nonetheless, for some unexplainable reasons, I expect "make clean" to do the usual thing, and it doesn't - this is probably easy to fix by having an almost empty libertas_tf/Makefile ? (this shows an older compat-wireless , but current compat-wireless also seem to have this problem
>> > if I remember correctly):
>> > ---------------
>> > scripts/Makefile.clean:17: /tmp/compat-wireless-2008-10-23/drivers/net/wireless/libertas_tf/Makefile: No such file or directory
>> > make[4]: *** No rule to make target `/tmp/compat-wireless-2008-10-23/drivers/net/wireless/libertas_tf/Makefile'.  Stop.
>> > make[3]: *** [/tmp/compat-wireless-2008-10-23/drivers/net/wireless/libertas_tf] Error 2
>> > make[2]: *** [/tmp/compat-wireless-2008-10-23/drivers/net/wireless] Error 2
>> > make[1]: *** [_clean_/tmp/compat-wireless-2008-10-23] Error 2
>> > make[1]: Leaving directory `/usr/src/kernels/2.6.27.5-92.fc10.x86_64'
>> > make: *** [clean] Error 2
>> > ---------------
>>
>> Try this patch, but the issue you see is related to libertas... anyway,
>> I've added this patch I'll try to see what's wrong with libertas.
>
> OK for your issue you can try this patch.

This patch should actually be useless to you as you probably are just
downloading the tarball.. so just download the latest tarball, I just
regenerated it with the patches applied.

  Luis
