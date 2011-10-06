Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59218 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759157Ab1JFVMd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Oct 2011 17:12:33 -0400
Received: by qadb15 with SMTP id b15so2367084qad.19
        for <linux-wireless@vger.kernel.org>; Thu, 06 Oct 2011 14:12:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E8E18DB.5070002@neratec.com>
References: <1317637758-11907-1-git-send-email-zefir.kurtisi@neratec.com>
 <201110041538.12885.chunkeey@googlemail.com> <CAB=NE6VC3txpDh4SdDKDxKWKKZVtGQXKVH8opszKDnZeeZTjUQ@mail.gmail.com>
 <201110061849.48838.chunkeey@googlemail.com> <CAB=NE6WbMi2GYJyFfvsdH-NSXn8dPBsgxgfdGXO_RHiJxwz2Fw@mail.gmail.com>
 <4E8E1062.1070206@neratec.com> <CAB=NE6XwNDc8v-qtQuQQZdh2ST-skpcZM7wqD32qHn3CgN-5Dw@mail.gmail.com>
 <4E8E18DB.5070002@neratec.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Thu, 6 Oct 2011 14:12:12 -0700
Message-ID: <CAB=NE6VRgGVg+f=Crhb3kE-wgtZOwdE5b-rhhn+qQqUOshWA6g@mail.gmail.com> (sfid-20111006_231236_482310_A29B35EF)
Subject: Re: [ath9k-devel] [RFC 5/6] ath9k: enable DFS pulse detection
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	kgiori@qca.qualcomm.com, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 6, 2011 at 2:08 PM, Zefir Kurtisi <zefir.kurtisi@neratec.com> wrote:
> On 06.10.2011 22:41, Luis R. Rodriguez wrote:
>> On Thu, Oct 6, 2011 at 1:32 PM, Zefir Kurtisi<zefir.kurtisi@neratec.com>  wrote:
>>> As said above, disabling a driver's capability through a Kconfig option
>>> should be enough (one ifdef per driver).
>>
>> OK cool.
>>
>>> Since regulatory compliance and open source by principle form a
>>> gray-zone combination [2], testing for sure is essential to keep it more
>>> white than black ;)
>>>
>>> [2] http://linuxwireless.org/en/developers/Regulatory/statement#Principles
>>
>> I actually do not think its grey now at all, we in fact IMHO have the
>> best regulatory framework out there, while still ensuring freedoms.
>>
>>    Luis
>
> Sorry, of course it is, I was not specific enough.
>
> I was just wondering if principle 3 generally would prevent us from
> adding a Kconfig option to enable DFS for ath9k as long as it is not
> certified (which is the only way to ensure to have a 'known compliant
> usage') plus depending on mac80211 and hostapd.

Ah yeah great point. I punted internally to see if there was a EEPROM
bit we can read that may tell us if a card is DFS certified. If that
is not available I think what we can do is leave the option but set
the default to disabled and simply state that only platforms that have
passed DFS certification should have it enabled.

 Luis
