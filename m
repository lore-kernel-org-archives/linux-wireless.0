Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:38275 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbbCWWdq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2015 18:33:46 -0400
Received: by wibgn9 with SMTP id gn9so77225188wib.1
        for <linux-wireless@vger.kernel.org>; Mon, 23 Mar 2015 15:33:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55109451.5060403@candelatech.com>
References: <1427133818-21480-1-git-send-email-greearb@candelatech.com>
 <CAGRGNgV4vTofdxq5G-DwDHMACyd13QT74wSnAbwqxA=1SJkU_Q@mail.gmail.com> <55109451.5060403@candelatech.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 24 Mar 2015 09:33:25 +1100
Message-ID: <CAGRGNgXh59ax8dObwhVUMQ+iso+4eAUWqLxMUT6mUXeiUK7E6Q@mail.gmail.com> (sfid-20150323_233349_899493_AC40F203)
Subject: Re: [PATCH 1/2] hs20-ca: Update key generation scripts and files.
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ben,

On Tue, Mar 24, 2015 at 9:31 AM, Ben Greear <greearb@candelatech.com> wrote:
> On 03/23/2015 03:16 PM, Julian Calaby wrote:
>> Hi Ben,
>>
>> On Tue, Mar 24, 2015 at 5:03 AM,  <greearb@candelatech.com> wrote:
>>> From: Ben Greear <greearb@candelatech.com>
>>>
>>> This lets us properly over-ride the default w1.fi
>>> related strings in order to properly generate keys
>>> that can be used by the OCSP process.
>>>
>>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>>> ---
>>>  hs20/server/ca/openssl.cnf | 12 ++++++------
>>>  hs20/server/ca/setup.sh    | 42 ++++++++++++++++++++++++++++++------------
>>>  2 files changed, 36 insertions(+), 18 deletions(-)
>>>
>>> diff --git a/hs20/server/ca/openssl.cnf b/hs20/server/ca/openssl.cnf
>>> index e29e737..c614479 100644
>>> --- a/hs20/server/ca/openssl.cnf
>>> +++ b/hs20/server/ca/openssl.cnf
>>> @@ -117,10 +117,10 @@ subjectKeyIdentifier=hash
>>>  authorityKeyIdentifier=keyid:always,issuer
>>>  basicConstraints = critical, CA:true, pathlen:0
>>>  keyUsage = critical, cRLSign, keyCertSign
>>> -authorityInfoAccess = OCSP;URI:http://osu.w1.fi:8888/
>>> +authorityInfoAccess = OCSP;URI:@OCSP_URI@
>>>  # For SP intermediate CA
>>>  #subjectAltName=critical,otherName:1.3.6.1.4.1.40808.1.1.1;UTF8String:engExample OSU
>>> -#nameConstraints=permitted;DNS:.w1.fi
>>> +#nameConstraints=permitted;DNS:.@DOMAIN@
>>>  #1.3.6.1.5.5.7.1.12=ASN1:SEQUENCE:LogotypeExtn
>>>
>>>  [ v3_osu_server ]
>>> @@ -184,7 +184,7 @@ extendedKeyUsage = OCSPSigning
>>>  basicConstraints=CA:FALSE
>>>  subjectKeyIdentifier=hash
>>>  authorityKeyIdentifier=keyid,issuer
>>> -authorityInfoAccess = OCSP;URI:http://osu.w1.fi:8888/
>>> +authorityInfoAccess = OCSP;@OCSP_URI@
>>
>> Are you sure this change is correct? You drop the "URI:" part here but
>> not above or below.
>
> You are correct, this is a bug.  I've fixed it locally,
> but not posted a new patch yet.  And, I'll post it to the hostapd
> mailing list instead of linux-wireless next time since that seems more
> appropriate.
>
> Thanks for the review!

I had no idea what the patch was for, but little inconsistencies like
that tend to jump out at me.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
