Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:63591 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407AbaDHFvq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2014 01:51:46 -0400
Received: by mail-we0-f173.google.com with SMTP id w61so418910wes.4
        for <linux-wireless@vger.kernel.org>; Mon, 07 Apr 2014 22:51:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53435F89.60500@candelatech.com>
References: <1396611464-5940-1-git-send-email-michal.kazior@tieto.com>
	<5341F1A9.2030202@candelatech.com>
	<CA+BoTQndgEB7X-RUPPkxdjnp96LJzbv6=Q9K4XTTrky-QwE4Ww@mail.gmail.com>
	<53435F89.60500@candelatech.com>
Date: Tue, 8 Apr 2014 07:51:45 +0200
Message-ID: <CA+BoTQk6G4-h8HQENbK9snrXo6j6FW4D+07XKZMEEuvWiu03ww@mail.gmail.com> (sfid-20140408_075150_128406_719233BB)
Subject: Re: [RFT 0/4] ath10k: fix flushing and tx stalls
From: Michal Kazior <michal.kazior@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8 April 2014 04:31, Ben Greear <greearb@candelatech.com> wrote:
> On 04/07/2014 02:11 AM, Michal Kazior wrote:
>
>> These logs are not enough. I'd love to see traces for this to see what
>> frames are actually submitted and when tx credits are replenished.
>>
>> I also wonder if this can be somehow related to your FW changes to
>> allow connecting multiple client virtual interfaces to a single AP?
>
>
> I think it is unlikely due to my firmware changes...little of that touched
> the handling of management frames.  It might very well be a basic problem in
> either the firmware or driver when using multiple station VIFS.  I think
> that
> aside from my testing that code has not been used much.
>
> Note my followup email that problems started with patch 3/4...not sure you
> saw that one or not.  I saw similar failure to associate & get DHCP (and
> slow/hung user-space) without the kernel error logs.

I did get that mail. It's just that it makes little sense. Patch 3/4
simply extends ath10k_flush() to wait for management frames. It
shouldn't change behaviour of tx credit starvation which appears to be
the case in the logs you provided.


> I've added the first two patches to my tree and will continue to run
> with them since they do not appear to cause problems so far.

Patch 2/4 is probably meaningless in itself. It is just a preparation for 4/4.

Anyway, thanks for testing!


Michał
