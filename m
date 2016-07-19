Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:35350 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261AbcGSSaf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2016 14:30:35 -0400
Received: by mail-pf0-f194.google.com with SMTP id h186so1826617pfg.2
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jul 2016 11:30:34 -0700 (PDT)
Subject: Re: [PATCH 0/4] brcm80211: Misc coverity fixes
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
	brcm80211-dev-list.pdl@broadcom.com
References: <1468884277-18606-1-git-send-email-f.fainelli@gmail.com>
 <bdbaa850-4ec4-9faf-dbae-e2a6dcc54e7c@broadcom.com>
 <578E5845.6030100@gmail.com>
 <53a36e85-37ad-10a5-81fc-40ce4efa6a65@broadcom.com>
Cc: linux-wireless@vger.kernel.org, pieterpg@broadcom.com,
	kvalo@codeaurora.org, hante.meuleman@broadcom.com
From: Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <578E71C8.1050003@gmail.com> (sfid-20160719_203038_711101_CAD8F7B5)
Date: Tue, 19 Jul 2016 11:30:32 -0700
MIME-Version: 1.0
In-Reply-To: <53a36e85-37ad-10a5-81fc-40ce4efa6a65@broadcom.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/19/2016 11:21 AM, Arend Van Spriel wrote:
> On 19-7-2016 18:41, Florian Fainelli wrote:
>> On 07/19/2016 02:20 AM, Arend Van Spriel wrote:
>>> + Bob
>>>
>>> On 19-7-2016 1:24, Florian Fainelli wrote:
>>>> Hi,
>>>>
>>>> This patch series addresses several coverity issues, they all seemed relevant
>>>> to me.
>>>
>>> Hi Florian,
>>>
>>> Been a while so nice to see coverity fixes popping up. Actually
>>> something that I have on my todo list to add our brcm80211 to coverity
>>> within Broadcom. So being curious as to whether this comes from a public
>>> coverity server like scan.coverity.com. Maybe bit redundant to setup
>>> internally if there is a good coverity analysis publicly available.
>>
>> This is coming from the public coverity instance, if you create an
>> account there I could transfer to you the other bugs that affect the
>> brcm80211 drivers (hint: there is a ton of of them because of
>> brcmf_fil_iovar_int_get and friends).
> 
> I did create an account and noticed "Broadcom Linux Kernel Open Source
> Repository" project. Anyways, let me have it :-p
> 
>>>
>>>> There is also a ton of warnings in Coverity caused by brcmf_fil_iovar_int_get()
>>>> and friends because of the initial access:
>>>>
>>>> __le32 data_le = cpu_to_le32(*data) which can utilize unitialized memory. I am
>>>> not sure if we actually care about any kind of initial, value, but if we don't,
>>>> then the fix should be fairly obvious.
>>>
>>> If we are talking only about "get" variant than we mostly don't care.
>>> Some getters support filter variables to be passed towards firmware. I
>>> have not looked at the analysis to give any judgement here.
>>
>> Alright, do you have a good way to test a patch that would just zero
>> initialize the data variable in brcmf_fil_iovar_int_get()? If so, I will
>> submit one with the appropriate CID references.
> 
> But why would we care to zero the data when firmware simply overwrites
> it. These control messages are not high-prio so we can burn some cycles
> to initialize the variable, but to me this is a false positive.

We have something like this all over the place:

func() {
	u32 val;

	brcmf_fil_iovar_int_get(..., &val, sizeof(val));
}

brcmf_fil_iovar_int_get(.., const u32 *data, size_t len)
{
	__le32 data_le = cpu_to_le32(*data);
	...
}

So here data_le also has an uninitialized value, and later on, this:


        buflen = brcmf_create_iovar(name, data, len, drvr->proto_buf,
                                    sizeof(drvr->proto_buf));

}

And this function does this:

static u32
brcmf_create_iovar(char *name, const char *data, u32 datalen,
                   char *buf, u32 buflen)
{
        u32 len;

        len = strlen(name) + 1;

        if ((len + datalen) > buflen)
                return 0;

        memcpy(buf, name, len);

        /* append data onto the end of the name string */
        if (data && datalen)
                memcpy(&buf[len], data, datalen);

        return len + datalen;
}


We are essentially copying into buf an uninitialized value coming from
the stack, which seems like a problem to me.
-- 
Florian
