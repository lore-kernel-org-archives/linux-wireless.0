Return-Path: <SRS0=IMqP=SN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7343C10F14
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Apr 2019 02:45:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80E53217D9
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Apr 2019 02:45:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbfDKCpd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Apr 2019 22:45:33 -0400
Received: from 178.115.242.59.static.drei.at ([178.115.242.59]:38146 "EHLO
        mail.osadl.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726106AbfDKCpd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Apr 2019 22:45:33 -0400
Received: by mail.osadl.at (Postfix, from userid 1001)
        id 025E35C2DC5; Thu, 11 Apr 2019 04:44:44 +0200 (CEST)
Date:   Thu, 11 Apr 2019 04:44:44 +0200
From:   Nicholas Mc Guire <der.herr@hofr.at>
To:     Adham.Abozaeid@microchip.com
Cc:     hofrat@osadl.org, Ajay.Kathat@microchip.com,
        gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] staging: wilc1000: give usleep_range a range
Message-ID: <20190411024444.GA5487@osadl.at>
References: <1554552067-15421-1-git-send-email-hofrat@osadl.org>
 <d38b17d8-5b0f-5b5e-2933-0626700e8546@microchip.com>
 <20190409013656.GA22293@osadl.at>
 <0360e5c6-28c8-db9e-1e8d-80445fe433c0@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0360e5c6-28c8-db9e-1e8d-80445fe433c0@microchip.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Apr 10, 2019 at 06:31:21PM +0000, Adham.Abozaeid@microchip.com wrote:
> Hi Nicolas
> 
> On 4/8/19 6:36 PM, Nicholas Mc Guire wrote:
> > On Mon, Apr 08, 2019 at 09:10:00PM +0000, Adham.Abozaeid@microchip.com wrote:
> >> Hi Nicholas
> >>
> >> On 4/6/19 5:01 AM, Nicholas Mc Guire wrote:
> >>> External E-Mail
> >>>
> >>>
> >>> Someone that knows the motivation for setting the time to 2 millisecond
> >>> might need to check if the 2 milliseconds where seen as tollerable max or
> >>> min - I'm assuming it was the min so extending.
> >> 2 msec is the time the chip takes to wake up from sleep.
> >>
> >> Increasing the maximum to 5 msec will impact the throughput since this call is on the transmit path.
> >>
> > ok - would it be tollerable to make it 2 - 2.5 ms ?
> > even that would allow for the hrtimer subsystem to optimize
> > a lot. In any case the min==max case gives you very little
> > if you run a test-case with usleep_range(1000,1000) and
> > a loop with usleep_range(1000,2000) and look at the distribution
> > you will have a hard time seeing any difference.
> 
> yes, I believe 2.5 shouldn't be a problem.
>
thanks - will send out a V2 then shortly.

thx!
hofrat 
