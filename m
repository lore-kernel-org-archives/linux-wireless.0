Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.191]:22693 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773AbYIRIqa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 04:46:30 -0400
Received: by rn-out-0910.google.com with SMTP id k40so2079015rnd.17
        for <linux-wireless@vger.kernel.org>; Thu, 18 Sep 2008 01:46:29 -0700 (PDT)
Message-ID: <43e72e890809180146q2a4062b8hf4e0911d3782c943@mail.gmail.com> (sfid-20080918_104635_262895_1800A4EF)
Date: Thu, 18 Sep 2008 01:46:29 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Mats Johannesson" <spamcan1@abrasax.se>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ath9k-devel] ath9k constantly drops network connection
Cc: "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20080918103628.5a6ab12c@loke.fish.not>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <e14212e0809170305v46b0c512i63c1a2874e730274@mail.gmail.com>
	 <20080917191003.GC6198@tesla> <20080918044618.0cd64cd9@loke.fish.not>
	 <20080918103628.5a6ab12c@loke.fish.not>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 18, 2008 at 1:36 AM, Mats Johannesson <spamcan1@abrasax.se> wrote:
> On Thu, 18 Sep 2008 04:46:18 +0200 Mats Johannesson wrote:
>> On Wed, 17 Sep 2008 12:10:03 -0700 Luis R. Rodriguez wrote:
>> > On Wed, Sep 17, 2008 at 03:05:59AM -0700, Partha Bagchi wrote:
>> [...]
>> > > 03:42:27 EDT 2008 i686 i686 i386 GNU/Linux
>> >
>> > Please try appling the patch titled:
>> >
>> > "[PATCH] ath9k: connectivity is lost after Group rekeying is done"
>> >
>> > which was posted on linux-wireless. If that fixes your issue I can
>>
>> A question Luis. Looking at the code (and not knowing _anything_ about
>> wireless internals):
>>
>> -             if (sc->sc_keytype == ATH9K_CIPHER_WEP)
>> +             if (tx_info->control.hw_key->alg == ALG_WEP)
>>                       txctl->keytype = ATH9K_KEY_TYPE_WEP;
>> -             else if (sc->sc_keytype == ATH9K_CIPHER_TKIP)
>> +             else if (tx_info->control.hw_key->alg == ALG_TKIP)
>>                       txctl->keytype = ATH9K_KEY_TYPE_TKIP;
>> -             else if (sc->sc_keytype == ATH9K_CIPHER_AES_CCM)
>> +             else if (tx_info->control.hw_key->alg == ALG_CCMP)
>>                       txctl->keytype = ATH9K_KEY_TYPE_AES;
>>
>> I'm confused regarding the AES cypher. My AP is set through its
>> interface as:
>>
>> Security Mode: WPA-Personal
>> WPA Mode: WPA2 Only
>> Cipher Type: AES
>> Group Key Update Interval: 2461 seconds (~41 minutes)
>> Pre-Shared Key: Loooong long key.
>>
>> But the output from "iwlist scan" tells another story:
>>
>>                     Encryption key:on
>>                     IE: IEEE 802.11i/WPA2 Version 1
>>                         Group Cipher : TKIP
>>                         Pairwise Ciphers (1) : TKIP
>>                         Authentication Suites (1) : PSK
>>
>> So someones lying... Does this effect ath9k?
>>
>> I'll compile another kernel and try to get rid of TKIP stuff
>> completely to test this out. At the moment the environment looks like
>> this:
>>
>> grep -i tkip my-.config
>> grep -i michael my-.config
>> # CONFIG_CRYPTO_MICHAEL_MIC is not set
>> grep -i ecb my-.config
>> CONFIG_CRYPTO_ECB=m
>> grep -i aes my-.config
>> CONFIG_CRYPTO_AES=m
>> CONFIG_CRYPTO_AES_X86_64=m
>>
>> loke@sleipner:~$ lsmod|grep -i ecb
>> ecb                     1344  2
>> crypto_blkcipher        8964  1 ecb
>> crypto_algapi           6336  6
>> aes_x86_64,aes_generic,arc4,ecb,crypto_blkcipher,cryptomgr
>>
>> loke@sleipner:~$ lsmod|grep -i aes
>> aes_x86_64              6784  3
>> aes_generic            25576  1 aes_x86_64
>> crypto_algapi           6336  6
>> aes_x86_64,aes_generic,arc4,ecb,crypto_blkcipher,cryptomgr
>>
>> Perhaps I'll break ath9k if the kernel lets me compile without an ecb
>> module...
>
> Well, it didn't let me deselect ecb since that is selected by MAC80211
> (as is arc4).
>
> Anyhow, writing now to share the good news that the patch you refer to:
> [PATCH] ath9k: connectivity is lost after Group rekeying is done
> (Click on [Download message RAW] at
> http://marc.info/?l=linux-wireless&m=122163541519736&w=2 to get a clean
> copy) completely fixes the regression between -rc5 and -rc6 I reported
> in:
>
> [ath9k-devel] 2.6.27-rc6 (and forwartd to -rc6-git3) dies silently.
> https://lists.ath9k.org/pipermail/ath9k-devel/2008-September/000263.html
>
> Patching -rc6-git3 I've now run 4 hours without a connection drop.
> Strangely enough it also allowed me to again make the connection
> 'sticky' over a reboot (Wicd Manager).
>
> This patch is a must have for 2.6.27 no matter what merging policy is
> in effect.

John please consider merging this for 27 as well as it fixes issues
reported due to lost of connectivity.

  Luis
