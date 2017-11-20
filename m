Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:9266 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751073AbdKTMKf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Nov 2017 07:10:35 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Peter Oh <peter.oh@bowerswilkins.com>
CC: Sven Eckelmann <sven.eckelmann@openmesh.com>,
        Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        Anilkumar Kolli <akolli@qti.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath10k: Fix reported HT MCS rates with NSS > 1
Date: Mon, 20 Nov 2017 12:10:30 +0000
Message-ID: <87po8df8wc.fsf@kamboji.qca.qualcomm.com> (sfid-20171120_131038_761008_45D3F88C)
References: <20170511090930.18205-1-sven.eckelmann@openmesh.com>
        <1728147.6Xy77nSgBU@bentobox>
        <d27a10b1-6323-ebf0-5c2d-4a9c3b8d978d@dd-wrt.com>
        <1960925.hkIbv4gX65@bentobox>
        <bfcfa3eb-fb45-cb8d-ad87-a5fe6dc96fe3@bowerswilkins.com>
In-Reply-To: <bfcfa3eb-fb45-cb8d-ad87-a5fe6dc96fe3@bowerswilkins.com> (Peter
        Oh's message of "Mon, 6 Nov 2017 13:25:42 -0800")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Peter Oh <peter.oh@bowerswilkins.com> writes:

> On 11/06/2017 01:02 AM, Sven Eckelmann wrote:
>> On Montag, 6. November 2017 09:28:42 CET Sebastian Gottschall wrote:
>>> Am 06.11.2017 um 09:23 schrieb Sven Eckelmann:
>>>> On Sonntag, 5. November 2017 10:22:22 CET Sebastian Gottschall wrote:
>>>>> the assumption made in this patch is obviously wrong (at least for mo=
re
>>>>> recent firmwares and 9984)
>>>>> my log is flooded with messages like
>>>>> [208802.803537] ath10k_pci 0001:03:00.0: Invalid VHT mcs 15 peer stat=
s
>>>>> [208805.108515] ath10k_pci 0001:03:00.0: Invalid VHT mcs 15 peer stat=
s
>>>>> [208821.747621] ath10k_pci 0001:03:00.0: Invalid VHT mcs 15 peer stat=
s
>>>>> [208822.516599] ath10k_pci 0001:03:00.0: Invalid VHT mcs 15 peer stat=
s
>>>>> [208841.257780] ath10k_pci 0001:03:00.0: Invalid VHT mcs 15 peer stat=
s
>> [...]
>>>> This patch only splits WMI_RATE_PREAMBLE_HT & WMI_RATE_PREAMBLE_VHT. A=
nd for
>>>> WMI_RATE_PREAMBLE_HT (*not VHT*), it uses a slightly different approac=
h. But
>>>> the WMI_RATE_PREAMBLE_VHT part (which you see in your logs) is basical=
ly
>>>> untouched.
>>> then a question follows up. is this check really neccessary?
>> Until we find out what the heck VHT MCS 15 should mean in this context -=
 maybe.
>> But to the message - no, the message is most likely not necessary for ea=
ch
>> received "invalid" peer tx stat.
>
> This validation check expects peer tx stat packets from FW contain
> reasonable values and gives warning if values are different from
> expectation. The problem comes from the assumption that "it always
> contains reasonable stat value" which is wrong at least based on my
> results. For instance, the reason MCS =3D=3D 15 is because all 4 bits of
> mcs potion set to 1, not because FW really sets it to 15
> intentionally. when the mcs potion bits are set to all 1s, the other
> bits such as nss are also set to all 1s.
> Hence it looks FW passed totally invalid stat info to me.
>
> I don't have preference on whether it's better to split VHT and HT
> check or not, but it is more appropriate to change that warning level
> to debug level.

I think we should add a special case to not print the warning if mcs =3D=3D
15 until we figure out what it means.

--=20
Kalle Valo=
