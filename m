Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61230 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404Ab1JVAre (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Oct 2011 20:47:34 -0400
Received: by gyb13 with SMTP id 13so4352651gyb.19
        for <linux-wireless@vger.kernel.org>; Fri, 21 Oct 2011 17:47:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20111021202038.GA1523@ecki.lan>
References: <CAJ-Vmo=5z6EEZBtb2_7e6wvU39ZvLSmAxEPKwP_MDQCzdkPGyA@mail.gmail.com>
	<20111005062528.GA1403@ecki>
	<CAJ-Vmok4v2+ZEpAmVaj2pQ5U2StWxxD8f20u2Ln87o4+C_ST0g@mail.gmail.com>
	<CAD2nsn1S7r2o0bqnNgzuHBd9XWYdA7uZgtmtFDTePk0SwybuCQ@mail.gmail.com>
	<20111015093902.GA23520@ecki>
	<CAJ-VmokQBcXyDByWgMfGRFvW_z_9YU4oPUrXJpfPY9J4riEuBQ@mail.gmail.com>
	<20111018064459.GA1442@ecki>
	<CAJ-Vmo=Qt3rGDbM0yOvFuz6Pksdx9bdm8HEBnhfjP6=zjGOgTA@mail.gmail.com>
	<20111021102221.GA1463@ecki.lan>
	<CAJ-Vmonaec_i5d_LGupY5uwzMUn3CzNn-rGSh6oqLOHc8ewFVg@mail.gmail.com>
	<20111021202038.GA1523@ecki.lan>
Date: Sat, 22 Oct 2011 08:47:33 +0800
Message-ID: <CAJ-Vmonu-75rtOyyqP7aWNA5NvQ7XW+0YB-G7N5gF3tS5E0EaA@mail.gmail.com> (sfid-20111022_024744_445042_1BA71901)
Subject: Re: ath9k: irq storm after suspend/resume
From: Adrian Chadd <adrian@freebsd.org>
To: Clemens Buchacher <drizzd@aon.at>
Cc: Mohammed Shafi <shafi.wireless@gmail.com>,
	linux-wireless@vger.kernel.org,
	ath9k-devel <ath9k-devel@lists.ath9k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

.. then I don't think it's specifically the NIC.

>From what I understand, unless there are bus errors happening (and
that'd occur with the NIC awake or having something being written to
it) the NIC shouldn't be generating interrupts if:

* sync/async cause are 0;
* ier is 0;
* imr is 0.

Now maybe some part of ath9k is still trying to write to the NIC when
it's asleep, but it would set some bits in sync_cause/async_cause.

At this point I'd really suggest whacking other devices into the slot
to see if they generate the same kind of behaviour.



Adrian
