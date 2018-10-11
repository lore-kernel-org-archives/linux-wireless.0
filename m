Return-Path: <SRS0=d2Dv=MX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 778BBC32788
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 10:05:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48FA32098A
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 10:05:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 48FA32098A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbeJKRcO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Oct 2018 13:32:14 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:57174 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726215AbeJKRcO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Oct 2018 13:32:14 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gAXqb-000877-JM; Thu, 11 Oct 2018 12:05:37 +0200
Message-ID: <1539252323.3687.207.camel@sipsolutions.net>
Subject: Re: [RFC v2] cfg80211: add peer measurement with FTM API
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Lior David <liord@codeaurora.org>, linux-wireless@vger.kernel.org
Cc:     Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>, luca@coelho.fi,
        Etan Cohen <etancohen@google.com>,
        Roy Want <roywant@google.com>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>
Date:   Thu, 11 Oct 2018 12:05:23 +0200
In-Reply-To: <0c64b665-5dc6-df94-4d49-a3adfc12f745@codeaurora.org>
References: <20181001133511.25046-1-johannes@sipsolutions.net>
         <b72e2702-64dd-4ac9-89a4-6fd4d03363ed@codeaurora.org>
         <1538942338.2928.21.camel@sipsolutions.net>
         <0c64b665-5dc6-df94-4d49-a3adfc12f745@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 (3.26.6-1.fc27) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2018-10-09 at 17:40 +0300, Lior David wrote:

> Thanks for the explanation. The send to same socket does sound more efficient.
> (In our internal implementation with vendor commands we were forced
> to send the results as broadcast...)

I suppose we can fix that, in the sense that we can add API to allow
vendor commands to know the socket to send back to etc.

> Yes as far as I remember rtt<->distance is a trivial calculation. What I meant
> here, you return the average of few measurements done in a burst, and for
> debugging we could return all the measurements done in the burst. For example if
> there were 4 measurements per burst return the 4 distance measurements done.

Ah, OK. I guess you'd have to report separate measurements or something.
Though if it's for debugging I'd think it may not make sense in this API
but rather something out-of-band.

> I meant we could have an AoA value (angle in degrees or other units) which
> drivers can fill up if they want. For example if the driver has 2 antennas on
> both sides it can report either 90 or 270 degrees. It will be usually very low
> accuracy but at least can provide some information like from which side of the
> AP you are. This can certainly be added later if at all (hopefully we will have
> AoA measurement with higher accuracy in the future)

Yeah, ok, I get it now - I guess we can add it if somebody plays with it
and finds how to obtain and use the value.

> > > For connected station, usually you will want to do the measurement on the
> > > connected channel (possibly some chips will not be able to do otherwise)
> > > Maybe add option to use default channel?
> > 
> > Perhaps. It's somewhat complicated to look up in general, userspace
> > generally has a decent idea, and making it optional means you end up
> > with an invalid chandef?
> > 
> > I'll take a look, perhaps just leaving all the fields 0/NULL can work
> > reasonably well, but drivers would have to support it.
> > 
> 
> As I remember the driver/FW can easily find the connected channel for connected
> station. For unconnected station we should probably force this parameter.

Should be able to, yes, but I suppose even userspace can. It just seems
like extra complexity to impose on the driver, since cfg80211 doesn't
necessarily have all the right information.

Actually, hmm, that would imply "use maximum bandwidth" or something?
And then what if that bandwidth isn't possible with FTM for some reason?
It's a bit tricky then.

> > If so, that sounds like something that generally needs improvement?
> > 
> 
> Good point. I see we currently use 20_NOHT for DMG, guess we can continue using it.

Well, I think it'd make more sense to just enforce the DMG bandwidth
everywhere, but I won't force the issue over this.

> Ok I thought 15 meant to actually request 65535 bursts :-)
> I still prefer the default to be 1 burst. Supporting the "no preference" means
> it will be difficult to pre-allocate memory for burst results. Also all drivers
> should know to do one burst.

Fair, I'll change it.

johannes
