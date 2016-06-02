Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:37091 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286AbcFBUcN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2016 16:32:13 -0400
Received: by mail-wm0-f46.google.com with SMTP id z87so83828838wmh.0
        for <linux-wireless@vger.kernel.org>; Thu, 02 Jun 2016 13:32:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABPxzYLe27gzQdEEU=5z6Bbmfduscjgry3gfQ6KRrWfngQt-Mg@mail.gmail.com>
References: <CAAfyv37Sr7JRtfrZYyb=c530sK8PR_ymeJ6w38274i1aDkHZ8A@mail.gmail.com>
	<CABPxzYLe27gzQdEEU=5z6Bbmfduscjgry3gfQ6KRrWfngQt-Mg@mail.gmail.com>
Date: Thu, 2 Jun 2016 22:32:11 +0200
Message-ID: <CAAfyv37zUXh+4g8Vr1Ee3ypfnA9ebNbx=xJ-cGBs3StaB-ANfQ@mail.gmail.com> (sfid-20160602_223216_824048_48F2B4BB)
Subject: Re: iw reg overwritten after connecting to AP
From: Belisko Marek <marek.belisko@gmail.com>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Krishna,

On Thu, Jun 2, 2016 at 10:21 PM, Krishna Chaitanya
<chaitanya.mgit@gmail.com> wrote:
> On Thu, Jun 2, 2016 at 7:34 PM, Belisko Marek <marek.belisko@gmail.com> wrote:
>>
>> Hello,
>>
>> I'm using kernel 4.1 with option CONFIG_CFG80211_INTERNAL_REGDB
>> enabled. I have set one country in db.txt which during startup I set
>> via 'iw reg set XX'. When connected to some AP which sends country
>> code (e.g. SK) region is overwritten to 00 (in kernel log there is
>> some timeout message - I suppose it's communication with crda daemon
>> which I'm not using). Is there a way how to override this behavior (to
>> keep my regulatory persistent). Many thanks.
>>
> You need to disable country_ie hints, you driver has to advertise
> REGULATORY_WIPHY_SELF_MANAGED in the wiphy.regualtory_flags
> to disable beacon and country_ie hints.
I would like to keep beacon hinting (maybe disable only country_ie). I
have same setup but with 3.9 kernel and regulatory isn't overwritten.
>
> Which driver are you using?
I'm using mwifiex driver

Thanks,

BR,

marek


-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com
