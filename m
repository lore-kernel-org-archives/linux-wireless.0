Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f176.google.com ([209.85.161.176]:33412 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756255AbcECTu2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2016 15:50:28 -0400
Received: by mail-yw0-f176.google.com with SMTP id t10so41187003ywa.0
        for <linux-wireless@vger.kernel.org>; Tue, 03 May 2016 12:50:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1462304144.10444.13.camel@sipsolutions.net>
References: <CABPxzYLtu53V79O--eDJEdRfn-zw3Wq9Po04F=uFp_FrfJjuiA@mail.gmail.com>
 <1462281243.2251.2.camel@sipsolutions.net> <CABPxzYJjRMMaUn+zzpzm8Zv8XAn8nfA8FgMTr7bkZve3XWs8ow@mail.gmail.com>
 <CABPxzYKj-0kaBP6BYQvcTYZtaTTbtc0nR-=69qC9eCDDJoXxaA@mail.gmail.com>
 <1462291262.2251.4.camel@sipsolutions.net> <CABPxzY+JXre1SzGyqmwYhTw9BB_-PfR02basW0WS34wZKpxK7g@mail.gmail.com>
 <CALhHN=pxE2+dHxKLvsdWDt7fZ-FwYSUzps6hWB9m7dmZbFytgg@mail.gmail.com> <1462304144.10444.13.camel@sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Wed, 4 May 2016 01:20:07 +0530
Message-ID: <CABPxzYL9ezhovark83mnSVkh7H3XQJjNU+XjvEHdMses6N3FBA@mail.gmail.com> (sfid-20160503_215030_852751_2A7630F3)
Subject: Re: dynamic ps + offchannel mgmt_tx + HW RoC
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 4, 2016 at 1:05 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> There is, btw, perhaps a different way - just fix the damn stuff.
>
> Requires moving everything into ifmgd rather than local, and then
> perhaps if only a single managed interface exists mirroring its state
> into the existing driver calls etc.
>
> It'd still be a big task, and I don't see much advantage over just
> reimplementing it.

Yes, requires quite an effort and also need to handle lot of cases.
Instead, why don't we make the default as complete PS offload
and force the drivers who need to use mac80211 PS negate these
in the register_hw? That way we are clear about the intentions.

-- 
Thanks,
Regards,
Chaitanya T K.
