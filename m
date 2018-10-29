Return-Path: <SRS0=ivqe=NJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53079C0044C
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 16:13:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A4A420657
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 16:13:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OVBe3tj5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1A4A420657
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727683AbeJ3BCm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 29 Oct 2018 21:02:42 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:39859 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727597AbeJ3BCl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Oct 2018 21:02:41 -0400
Received: by mail-lf1-f65.google.com with SMTP id p11-v6so6488375lfc.6;
        Mon, 29 Oct 2018 09:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=eYWHVdhWDDpgJ2V9xAcamwTCuB5W5kVeb46h2M75ePI=;
        b=OVBe3tj5nmWSNqkZAZWR6DTnE6lm+LuM3BWOypqYrO83jI35gm7uVpqHRmlYV0F0+e
         zdzIwn303SpLcyc2hvd2FpiC5ZqZJKo458WqtWfPTKlNlruSBtLzeLDyMIKzPpIaHB8D
         6wJPlOiL0wo+iPsJi94RIHtsjD9UuKw5E5Vf8PYVgVN4YeChPopjAD+F5O3GksYPt+Mq
         LMX38XaX5yfP8Uq7XgxCCVppxHGaNPGWlvwtu1UUcs2C6Cj7AzYlhf72zyvXl8pQgShk
         L758GXrDt3HFlVrEr4UN9gezWFspeGMmRVws+t08ltPJpOWM5a7KDApUFcKzlby7LmwE
         RsMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=eYWHVdhWDDpgJ2V9xAcamwTCuB5W5kVeb46h2M75ePI=;
        b=SPsyXkDkG8H9dCe2Y34Dlv6/lU6+bygJS2Pt2k+RUt13q90iyV5Cn4KunaPO49bV6S
         EPWLqr7YKBWznt8RvzVjUaaK6b0OcsgaAxwbIsmRv1DrQhDdw844AOnhv7UkDvGyxMa7
         w7kKH9h+35+aick/LJyVNkSTGby9qtHRwGY5amoR0S1rAB3aOY2rPHx0p9m9c/KM9PVs
         4jOKZPxgR71o2W+FNPUGzMYim+UWNaInfDlhCU8/UkcufhXFPoLmGbWyuWeqc367BKHX
         eCRxIGqnP2uOmsocQjCx46+SRV6AtLvL90iL6TSKcvwIsNZBstFef8xMFhP8wEES3V1m
         M87A==
X-Gm-Message-State: AGRZ1gKovccZlKSizzytWK1TPZjTdPLlo+X7zpcMTO0oiN5asEWcptnH
        Nd0W7JQXY06Dl2WJ2ybKXnbLyUOO
X-Google-Smtp-Source: AJdET5c0qA6cFzfJmfCFpfbnNHFdjAtHBaLfsHoBkzUcbHoRpeUOpuO0w6cHf0L/clLVwAyNJA5m+w==
X-Received: by 2002:a19:4e59:: with SMTP id c86mr9038690lfb.132.1540829603958;
        Mon, 29 Oct 2018 09:13:23 -0700 (PDT)
Received: from xi.terra (c-74bee655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.190.116])
        by smtp.gmail.com with ESMTPSA id 2-v6sm3103567ljv.83.2018.10.29.09.13.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Oct 2018 09:13:23 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.91)
        (envelope-from <johan@kernel.org>)
        id 1gHAAS-0003cz-Ij; Mon, 29 Oct 2018 17:13:28 +0100
Date:   Mon, 29 Oct 2018 17:13:28 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Lars Poeschel <poeschel@lemonage.de>
Cc:     Johan Hovold <johan@kernel.org>, devicetree@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NFC SUBSYSTEM" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3 3/5] nfc: pn533: add UART phy driver
Message-ID: <20181029161328.GT27852@localhost>
References: <20181025132937.24405-1-poeschel@lemonage.de>
 <20181025132937.24405-3-poeschel@lemonage.de>
 <20181028102725.GL27852@localhost>
 <20181029100246.GA5905@lem-wkst-02.lemonage>
 <20181029110704.GQ27852@localhost>
 <20181029155110.GA12914@lem-wkst-02.lemonage>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181029155110.GA12914@lem-wkst-02.lemonage>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Oct 29, 2018 at 04:51:10PM +0100, Lars Poeschel wrote:
> On Mon, Oct 29, 2018 at 12:07:04PM +0100, Johan Hovold wrote:

> > > Wouldn't that be the scope of another later patch then ?
> > 
> > Possibly. We have accepted some serdev drivers already taking the lazy
> > approach of opening the port in probe. Depending on the driver, it may
> > not be too bad (e.g. for some specific hardware which you know you'll
> > always use), but it not really nice to have everyone pay a price in
> > terms of power-consumption for a feature that is rarely used.
> 
> Is there a way in serdev to close a port, but still occupy it ?
> I'd like to do the basic chip initialisation in _probe and then close
> the port for power-consuption reasons. I'd like to have the port still
> occupied, so that it's not available to other possible users in the
> meantime. I'd then do a serdev open again in dev_up and really use it
> from there.
> dev_down is then for serdev close and also still occupy it.
> closing and releasing would then be done in _remove.

The serdev device is bound you driver regardless of whether you open the
port or not, so just use serdev_device_open() and serdev_device_close()
as necessary at probe() if you need to do some setup and then later at
dev_up() and dev_down(), respectively.

Johan
