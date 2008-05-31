Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.175]:61974 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338AbYEaU3O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 May 2008 16:29:14 -0400
Received: by wf-out-1314.google.com with SMTP id 27so313126wfd.4
        for <linux-wireless@vger.kernel.org>; Sat, 31 May 2008 13:29:13 -0700 (PDT)
Message-ID: <69e28c910805311329v8f29c42mbb97ab553cc6e96c@mail.gmail.com> (sfid-20080531_222917_244646_989CA888)
Date: Sat, 31 May 2008 22:29:13 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: Wireless-testing's b43 panics in b43_generate_txhdr on packet transmit
Cc: "Michael Buesch" <mb@bu3sch.de>, "Pavel Roskin" <proski@gnu.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>,
	linux-kernel@vger.kernel.org
In-Reply-To: <1212265322.7672.2.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <69e28c910805310723j2b721030x2609cc9e866abafa@mail.gmail.com>
	 <200805311841.46740.mb@bu3sch.de> <1212252636.2766.10.camel@rd>
	 <200805311954.46639.mb@bu3sch.de>
	 <1212265322.7672.2.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 31, 2008 at 10:22 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sat, 2008-05-31 at 19:54 +0200, Michael Buesch wrote:
>> On Saturday 31 May 2008 18:50:36 Pavel Roskin wrote:
>> > On Sat, 2008-05-31 at 18:41 +0200, Michael Buesch wrote:
>> > > On Saturday 31 May 2008 18:34:29 Stefanik G=E1bor wrote:
>> > > > "BUG: unable to handle kernel NULL pointer dereference at 0000=
0004
>> > > > IP: [<f8dd3a99>] :b43:b43_generate_txhdr+0x6a9/0x790
>> > >
>> > > So can you put a few printks into the function to see where it d=
ereferences
>> > > a NULL pointer? (or use gdb to lookup the offset).
>> >
>> > u8 key_idx =3D info->control.hw_key->hw_key_idx;
>> >
>> > info->control.hw_key is NULL.
>>
>> Is a NULL pointer supposed to tell "do not encrypt", or is this a ma=
c80211 bug?
>
> It's probably a bug.
>
> johannes
>

Should we assume that it's the first key if it happens?
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
