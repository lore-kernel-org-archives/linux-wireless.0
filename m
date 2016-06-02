Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f181.google.com ([209.85.161.181]:33260 "EHLO
	mail-yw0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbcFBUVg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2016 16:21:36 -0400
Received: by mail-yw0-f181.google.com with SMTP id h19so61368556ywc.0
        for <linux-wireless@vger.kernel.org>; Thu, 02 Jun 2016 13:21:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAfyv37Sr7JRtfrZYyb=c530sK8PR_ymeJ6w38274i1aDkHZ8A@mail.gmail.com>
References: <CAAfyv37Sr7JRtfrZYyb=c530sK8PR_ymeJ6w38274i1aDkHZ8A@mail.gmail.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Fri, 3 Jun 2016 01:51:15 +0530
Message-ID: <CABPxzYLe27gzQdEEU=5z6Bbmfduscjgry3gfQ6KRrWfngQt-Mg@mail.gmail.com> (sfid-20160602_222140_762016_38C966E9)
Subject: Re: iw reg overwritten after connecting to AP
To: Belisko Marek <marek.belisko@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 2, 2016 at 7:34 PM, Belisko Marek <marek.belisko@gmail.com> wrote:
>
> Hello,
>
> I'm using kernel 4.1 with option CONFIG_CFG80211_INTERNAL_REGDB
> enabled. I have set one country in db.txt which during startup I set
> via 'iw reg set XX'. When connected to some AP which sends country
> code (e.g. SK) region is overwritten to 00 (in kernel log there is
> some timeout message - I suppose it's communication with crda daemon
> which I'm not using). Is there a way how to override this behavior (to
> keep my regulatory persistent). Many thanks.
>
You need to disable country_ie hints, you driver has to advertise
REGULATORY_WIPHY_SELF_MANAGED in the wiphy.regualtory_flags
to disable beacon and country_ie hints.

Which driver are you using?
