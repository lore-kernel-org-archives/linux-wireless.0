Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:2761 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754865AbZDOQIh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2009 12:08:37 -0400
Received: by yw-out-2324.google.com with SMTP id 5so3162096ywb.1
        for <linux-wireless@vger.kernel.org>; Wed, 15 Apr 2009 09:08:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49E5F99E.1090809@tuffmail.co.uk>
References: <9b2b86520904150345r31851012jb6a231e02583038a@mail.gmail.com>
	 <9b2b86520904150358u81dd977g3378ef81d7748355@mail.gmail.com>
	 <20090415130232.GA21411@tuxdriver.com> <49E5EC66.80408@tuffmail.co.uk>
	 <b6c5339f0904150809p308d8eedt83198f12a7887f7e@mail.gmail.com>
	 <49E5F99E.1090809@tuffmail.co.uk>
Date: Wed, 15 Apr 2009 12:08:35 -0400
Message-ID: <b6c5339f0904150908nb23cf89n9f36bba5a29f955e@mail.gmail.com> (sfid-20090415_180858_762070_97576927)
Subject: Re: [ath5k-devel] BUG in freq_reg_info_regd
From: Bob Copeland <bcopeland@gmail.com>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Pavel Roskin <proski@gnu.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> Hmm, null pointer is probably custom_regd since reg_rule comes from
>> the stack and wiphy should've been validated a lot earlier.
>>
>> Mind posting the objdump -S net/wireless/reg.o ?
>>
>
> Sure. =A0It's 120k so I trimmed the CC list.

Darn, no debug info..  In hindsight I should've just asked for
the scripts/markup_oops.pl treatment :)

Ok, I was wrong: it's last_request.  This looks very similar to the bug=
 you
had a few days ago to which Pavel Roskin responded.  I don't think anyt=
hing
changed wrt last_request initialization, so maybe some kind of module
loading race again?

> 00000184 <freq_reg_info_regd>:
[...]
> =A0 =A0 1a6: =A0 =A0 =A0 0f 45 d0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cmov=
ne %eax,%edx
> =A0 =A0 1a9: =A0 =A0 =A0 a1 04 00 00 00 =A0 =A0 =A0 =A0 =A0mov =A0 =A0=
0x4,%eax
> =A0 =A0 1ae: =A0 =A0 =A0 8b 40 04 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mov =
=A0 =A00x4(%eax),%eax

here's where it crashes, loading last_request->initiator into eax

> =A0 =A0 1b1: =A0 =A0 =A0 83 f8 03 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cmp =
=A0 =A0$0x3,%eax

=3D=3D NL80211_REGDOM_SET_BY_COUNTRY_IE

> =A0 =A0 1b4: =A0 =A0 =A0 74 26 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 je=
 =A0 =A0 1dc <freq_reg_info_regd+0x58>
> =A0 =A0 1b6: =A0 =A0 =A0 48 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
dec =A0 =A0%eax
> =A0 =A0 1b7: =A0 =A0 =A0 74 23 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 je=
 =A0 =A0 1dc <freq_reg_info_regd+0x58>
> =A0 =A0 1b9: =A0 =A0 =A0 8b 73 30 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mov =
=A0 =A00x30(%ebx),%esi

--=20
Bob Copeland %% www.bobcopeland.com
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
