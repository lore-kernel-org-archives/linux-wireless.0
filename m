Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:34183 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbbCLGMv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 02:12:51 -0400
Received: by wgha1 with SMTP id a1so14077386wgh.1
        for <linux-wireless@vger.kernel.org>; Wed, 11 Mar 2015 23:12:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1426090976.1904.7.camel@sipsolutions.net>
References: <1426080326-14764-1-git-send-email-michal.kazior@tieto.com>
	<1426090976.1904.7.camel@sipsolutions.net>
Date: Thu, 12 Mar 2015 07:12:49 +0100
Message-ID: <CA+BoTQ=K_vxuB7my+4W5pLgmmdd7p-srqEM9O1=gwWLqzJhCkQ@mail.gmail.com> (sfid-20150312_071314_490096_1AD725F7)
Subject: Re: [PATCH] ath10k: strip qos data bit always
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11 March 2015 at 17:22, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2015-03-11 at 14:25 +0100, Michal Kazior wrote:
>> NativeWifi tx mode expects QoS Data frames to be
>> delivered as Data frames with QoS part (e.g. tid)
>> being delievered out-of-band in fw tx command.
>>
>> The QoS bit wasn't stripped before submitting to
>> firmware.
>>
>> Stripping fixes two known problems:
>>
>>  * qca6174 IOT with some APs, e.g.
>>    Cisco AIR-AP 1252 (which would crash after
>>    ath10k association). Some ath9k APs would
>>    crash as well.
>
> It would probably be interesting to figure out why and fix that - this
> is clearly a major issue.

Good point. The patch was originally just a small fix for sniffing but
it happened to fix the IOT problem that we started seeing with the new
chip fw as well.

I believe that if 11n was disabled on APs the problem did not
reproduce. I think ath9k was crashing somewhere along the BA session
teardown (as per kernel call trace). The ath9k codebase from what I
know was rather old (some custom 3.4 fork) so perhaps it was a race of
some sort that has been fixed long since.

I'll try to get some sniff logs and take a look at this more closely.


Michał
