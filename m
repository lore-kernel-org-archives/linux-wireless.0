Return-Path: <SRS0=Jk3u=RW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB8D1C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 02:37:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 772C42085A
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 02:37:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gjS65iVs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727244AbfCSCh2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Mar 2019 22:37:28 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:34121 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727030AbfCSCh2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Mar 2019 22:37:28 -0400
Received: by mail-ot1-f66.google.com with SMTP id r19so16373508otn.1
        for <linux-wireless@vger.kernel.org>; Mon, 18 Mar 2019 19:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=hngMdJ9dLq62MKzrhHinT5XoCXsHjtG5akXdXLZQkNw=;
        b=gjS65iVsTnYyPpmHXupXVC7q5bXphbvTi1dZcEH0mRmz4NN1jq4k0ZojSE9bOREvft
         ZXZyP/vmcXt8VNvYIM+PIq/Hh6KvvA4hfosTjJ5E3ynYoRigpAMm9hkC9TA5MMi+Cs1+
         Gb1pWKthCDsHfU7woUfXUUVYzOsLalpzUDgSmEUeqSE9x+EXprqRuKMG7Lxxw/gH1B47
         Krv8yHHYzouPvAbLLS3H8yTt58F0apWjuRTyMUfRDBgrXjWKLa+iFE94iKUq0Wou5Ioh
         g8BO8nmhWWxP7npI44HQISzpeCt5KM6mYYa0C4tBGt7yaOHduJ1bcp3FO461RZzOUNxp
         sdkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=hngMdJ9dLq62MKzrhHinT5XoCXsHjtG5akXdXLZQkNw=;
        b=roaMKKXieRx+uLkTJ7c7V8iBXs9y6xUmDaFFWnmvkGw3I1VfOQs//faMLVoJhWVz4M
         w7QI+X5WEeoIuqYmkFOKgfvwoHuohFMiikqJxTYu+cPI/P56omwpo8ewc2t2ibU39OEj
         ujz6vYzVX+MINvdsGXjgBN42Q/0WrFH5b3sidJVV+yvs4vGFHZQTC9fmpOghqoOS0D9f
         eyDAbH53eiEw63APBL9nSjJtpk7luNhqhFfj+ifn3wpUCMZuWMPlrGN1pQEEabQtwgwa
         dUJ+Cdc9i/9cAOEkIkgsiY2t1ImEAdRXo1m50tjP8hC2R7DavJ9UVl1Q4RG3WaX/r1KO
         SF0A==
X-Gm-Message-State: APjAAAWGmIruQ4I/XE1QWqiaCCN54tmHMZ+6ttMcI8u61y0E6VwlVy/6
        JrvjNSIm5mKy7gfVwSLcrprlYafmTvM+ySYgcJA=
X-Google-Smtp-Source: APXvYqy+t5WBCrZwaL6ONk0BrEeu0FZdddbuHNSznmJ4rUxGc4dsTJm7qUK0UOrYQbAQjVtwIVpk7tuHkOqRbj36UnE=
X-Received: by 2002:a9d:6e0a:: with SMTP id e10mr7749843otr.281.1552963047868;
 Mon, 18 Mar 2019 19:37:27 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9d:628c:0:0:0:0:0 with HTTP; Mon, 18 Mar 2019 19:37:27
 -0700 (PDT)
In-Reply-To: <20190209172825.GB19297@makrotopia.org>
References: <CAKR_QVKQMcGGpY_3ur9kFjuYpaKgca=YfUJxjSjLEfP1HELuJw@mail.gmail.com>
 <20181227102535.GA25885@redhat.com> <CAKR_QVK_2j6a9YiwUEKuWF+ss0-pr808Sr=AUrX4a6L3Zw=F0w@mail.gmail.com>
 <20190102081934.GA5300@redhat.com> <20190209110259.GA14900@redhat.com>
 <CAKR_QVK7N_NGFR+_2+6fP5iZ0j3dDbvdxJOQt3Yjwn7DMBUfYA@mail.gmail.com>
 <20190209115628.GA16082@redhat.com> <CAKR_QVJtQdRcbRMV+WDKw=N2CxLhUSo6hE8mUME2orD6JEMAmQ@mail.gmail.com>
 <20190209153850.GA19297@makrotopia.org> <CAKR_QVJXaYyy64BBj0qz7-Rua70nKGTypV7uiysCqyR=jG_Adw@mail.gmail.com>
 <20190209172825.GB19297@makrotopia.org>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Tue, 19 Mar 2019 03:37:27 +0100
Message-ID: <CAKR_QVJn96DnzXW=6fHQvw4z_ia+0D1mcv76VGzq0gjaJDOTmg@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] rt2x00: do not print error when queue is full
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless@vger.kernel.org,
        Randy Oostdyk <linux-kernel@oostdyk.com>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 09/02/2019, Daniel Golle <daniel@makrotopia.org> wrote:

>>20MiB/s download rate is very impressive for 2.4GHz WiFi, I never saw
> anything even near that (using BitTorrent I get up to 8MiB/s when next
> to the router in low-noise environment with proprietry ubiquiti gear).

various apps and data transfer stacks may add significant overhead.
for real throughput testing i rely on iperf2 (tried iperf3 it was
mess). if interested take a look at bandwidth achieved on OCed QCA9531
device: https://forum.openwrt.org/t/different-wifi-speed-tx-rx-archer-c7-v2/18860/10?u=psyborg
