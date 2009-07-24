Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f213.google.com ([209.85.217.213]:32902 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbZGXN6t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2009 09:58:49 -0400
Received: by gxk9 with SMTP id 9so3107294gxk.13
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2009 06:58:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A68E80C.808@redfish-solutions.com>
References: <4A612514.4050708@redfish-solutions.com>
	 <43e72e890907201247x7df76b75wf6ba2bc2260dbf7a@mail.gmail.com>
	 <4A650331.9020409@redfish-solutions.com>
	 <4A6620B9.4@redfish-solutions.com>
	 <20090723112428.GC13742@hash.localnet>
	 <b6c5339f0907230459g75cef6eag1ad0caa7b1a631b8@mail.gmail.com>
	 <4A68C821.7060208@redfish-solutions.com>
	 <4A68DBDE.7060504@redfish-solutions.com>
	 <b6c5339f0907231521v37b44d45t1852d0c5f97bc4fb@mail.gmail.com>
	 <4A68E80C.808@redfish-solutions.com>
Date: Fri, 24 Jul 2009 09:58:48 -0400
Message-ID: <b6c5339f0907240658o38f4ee76t2de8a071cd2f37f4@mail.gmail.com>
Subject: Re: Using compat-wireless w/ 2.6.27.26
From: Bob Copeland <me@bobcopeland.com>
To: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 23, 2009 at 6:45 PM, Philip A.
Prindeville<philipp_subx@redfish-solutions.com> wrote:
> Bob Copeland wrote:
>> On Thu, Jul 23, 2009 at 5:53 PM, Philip A.
>> Prindeville<philipp_subx@redfish-solutions.com> wrote:
>>>> Getting closer :-)
>>>>
>>>> ath5k_tx_processq(sc, &sc->txqs[i]);
>>>>
>>> Didn't work with rc4:
>>
>> What did you apply against?  It's supposed to be against
>> wireless-testing (or, at worst, latest compat-wireless).
>>
>>> BUG: unable to handle kernel NULL pointer dereference at 00000000
>>> IP: [<d0935658>] :ath5k:ath5k_tasklet_tx+0x5e/0x27b
>>

> This was against compat-wireless-2.6.31-rc4.
>
> Alas, I already blew away the build directory...

I think you need to use the unstable compat-wireless snapshots;
I have a feeling that the above doesn't have all of the tx queues.

Check out ath5k.h, the txq array in struct ath5k_softc should have
NUM_TX_QUEUES entries, an earlier version only had 2.

Although your compiler generates rather different code from mine
(different config or whatever), it looks like the oops happened
in the list_for_each_entry(... txq->q ...) -- but I don't see how
that can happen in my copy, since txq[i].q is initialized at the
same time as txq[i].setup.

-- 
Bob Copeland %% www.bobcopeland.com
