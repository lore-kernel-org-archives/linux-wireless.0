Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.248]:1687 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755764AbZCDTsA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Mar 2009 14:48:00 -0500
Received: by an-out-0708.google.com with SMTP id c2so2518261anc.1
        for <linux-wireless@vger.kernel.org>; Wed, 04 Mar 2009 11:47:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1236194370.6612.73.camel@rc-desk>
References: <760481.57662.qm@web57614.mail.re1.yahoo.com>
	 <c4d76b3b0901261913s23427b19tbbe34ee7b4261068@mail.gmail.com>
	 <c4d76b3b0901261935n1846b675w72cfa7308d198080@mail.gmail.com>
	 <20090127162437.GA3596@sortiz.org>
	 <c4d76b3b0901271531q19578871idbc59b5a23ac868e@mail.gmail.com>
	 <1ba2fa240901272312j270eedb5x33534a9703d26e06@mail.gmail.com>
	 <20090128113751.GA3197@sortiz.org>
	 <c4d76b3b0903011937p6538adbfpc0dab859a6742394@mail.gmail.com>
	 <1236141120.12734.2.camel@rainbow> <1236194370.6612.73.camel@rc-desk>
Date: Wed, 4 Mar 2009 14:47:56 -0500
Message-ID: <c4d76b3b0903041147s2138e72bjb39864f87b4cd09e@mail.gmail.com> (sfid-20090304_204806_305410_24E203C9)
Subject: Re: kernel BUG at drivers/net/wireless/iwlwifi/iwl3945-base.c:3127!
From: Jason Andryuk <jandryuk@gmail.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: Samuel Ortiz <samuel@sortiz.org>, Tomas Winkler <tomasw@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 4, 2009 at 2:19 PM, reinette chatre
<reinette.chatre@intel.com> wrote:
> On Tue, 2009-03-03 at 20:32 -0800, Jason Andryuk wrote:
>> On Sun, Mar 1, 2009 at 10:37 PM, Jason Andryuk <jandryuk@gmail.com> =
wrote:
>> > I tested c2a0aa3cb733452e749727680e380dca6cc10a68 "iwl3945: use
>> > iwl_rb_status" with the additional patches to initialize rb_stts
>> > (copied from iwl_rx_queue_alloc) and to convert the BUG_ON to a
>> > WARN_ON.
>> >
>> > The driver runs without segfaulting. =A0So far the WARN_ON has not=
 been
>> > triggered, but the driver fails to finish authentication with the =
AP.
>> > I receive "wlan0: authentication with AP 00:30:bd:c0:90:24 timed o=
ut"
>>
>> Ok, I started poking around with manually checking interesting commi=
ts instead of git bisect.
>>
>> 55b3e21... iwl3945: use iwl-io.h and delete iwl-3945-io.h with BUG->=
WARN patch works.
>>
>> bb64785... iwlwifi: use iwl_cmd instead of iwl3945_cmd
>> fails to authenticate to the AP. =A0It generates a Microcode SW Erro=
r attached below.
>>
>> The previous revision:
>> a0dedce... iwlwifi: replace IWL_ERROR with IWL_ERR
>> Authenticates to the AP and works just fine.
>>
>> I keep looking over commitdiff bb64785... but I cannot see what is c=
ausing problems. =A0I even tried modifying iwl3945_cmd in various ways =
from a0dedce... but those attempts kept working.
>>
>> During testing, I saw a lot of UNKNOWN 0x1b
>> [ 8892.625374] ieee80211 phy0: I iwl3945_rx_handle r =3D 162, i =3D =
160, UNKNOWN, 0x1b
>> Currently in the logs for commit a0dedce... it shows up as REPLY_394=
5_RX.
>>
>> Any ideas?
>
> Thank you very much for this digging.
>
> Are you running on 64bit?

Yes, 64bit.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
