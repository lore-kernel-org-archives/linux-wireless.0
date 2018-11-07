Return-Path: <SRS0=0pA5=NS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C83FFC0044C
	for <linux-wireless@archiver.kernel.org>; Wed,  7 Nov 2018 08:07:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F88F2081D
	for <linux-wireless@archiver.kernel.org>; Wed,  7 Nov 2018 08:07:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kapsi.fi header.i=@kapsi.fi header.b="x4y/2OwS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0F88F2081D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=digip.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728524AbeKGRg1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 7 Nov 2018 12:36:27 -0500
Received: from mail.kapsi.fi ([91.232.154.25]:38807 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726298AbeKGRg1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Nov 2018 12:36:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=kapsi.fi;
         s=20161220; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+2cumHsdktVBT9rXScRjKRXztpkDyGKbCXjUyORpQe8=; b=x4y/2OwS1eJwZumoExOMMAQzPD
        /Bk8CS6kcE6hJwyj9h76YBkk/55kuF9uXRKDCKLHpBetKKVyQ2A/DB6Uu6hPlWhNqxwNLLvYZzdfV
        dZ8MxtuCX3+/0vAcSalXg6+NHAPWq3gSHDrpdBNi8f78Fv50vzXjPtmaIVal/A0cNJQuV63u8N+l2
        HvF4pnPPsMj52c9xzQywL4nk3RxIWRvhoamUd92oHKyfR0IkrAEwVn8yGHoadSHwF9J7HnqHIvQfA
        fxBmL/1vRei9rr4AMnGYSte8pVhbO2erWrum+FZhm5eZGEXF8XJt2XyoCQWgOLO7y8tSraQ237xJ5
        u/ZyjzCw==;
Received: from [87.94.15.202] (helo=localhost)
        by mail.kapsi.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <petri@digip.org>)
        id 1gKIrn-0007su-IA; Wed, 07 Nov 2018 10:07:11 +0200
Date:   Wed, 7 Nov 2018 10:07:11 +0200
From:   Petri Lehtinen <petri@digip.org>
To:     Emmanuel Grumbach <egrumbach@gmail.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Intel 8265 iwlwifi broken on recent linux-firmware
Message-ID: <20181107080711.GA5450@ping.localdomain>
References: <20181107053439.GA2730@ping.localdomain>
 <CANUX_P12CoQtT8RzawXSC+VwzgHVuPTbrqyyEJYuX48PCJFMxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="IJpNTDwzlM2Ie8A6"
Content-Disposition: inline
In-Reply-To: <CANUX_P12CoQtT8RzawXSC+VwzgHVuPTbrqyyEJYuX48PCJFMxg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 87.94.15.202
X-SA-Exim-Mail-From: petri@digip.org
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Emmanuel Grumbach wrote:
> I checked the diff between e91976c0 and 7596afd4 and it is very very small.
> Is your machine dual boot?
> A few users have reported a race between BT firmware load and Wifi
> firmware load. They also reported that booting in Windows, and then
> shutting down in Windows helps to boot Linux properly.

Hi!

It was actually 2 weeks ago when I noticed the problem, and I've used
the older firmware since then. I just had in the bottom of my
"backlog" to report this somewhere. I now tested again with the newer
firmware, and this time it seems to work!

My machine is not dual boot, but I've had several warm and cold boots
in between. Maybe this had an effect? Dunno, but now it works.

Thanks, and sorry for the noise.

Petri

--IJpNTDwzlM2Ie8A6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEtdaVPm1QWe162g8v02V9JNBYQ0wFAlvinSwACgkQ02V9JNBY
Q0xCsQ//QjBo73H4qR4mdR5udCFeRCdZnnZQlufFDDV2W+CROMV/kwUPM+FnCEWW
oshMHL9mIkeT3SmMT+MfUJh2hovbpN46vJRR+sKaBc0+/Qp+pjNO8cWP0FuhrdPX
i9C4SRGhuL/0tdTRMKOlpEIvzlxkmKQUYgBxRkmRcd1mjg11pmqRmU76L7i015x5
gXrMYczf65rt7UamZv3wGNMRFcQlfdAIVtpBMFOdNpaDZOLRlSGVgDCPuMjXFnFJ
f4EBL00D8Bntj+5/6KZwoeVf22qt3eZPfGe41D+R2njiJg3bC8ZSfvyLzUknoBKy
JRkOe1c9A1eI4BrpPVNRCtyM3swAk7Ulcv2JgPHZ9fs04sbwpwFKwpXqQ9YjVrb4
Rp6/fRlcKJZavNtI/hIUAqcR51j9s9rlkATbWCfafyGSp0J7N8NirBiEDEkyYfxL
zFup3ZSNZeUWhs55Na3oUJJS3FDfcBEB7idqZn3NAn7TdSkFSWmX1D2pD4haSXbc
HTZpLQIIU1YQBldf1VkVtLovlRvdsxwd6Wr1oFRpgS9JNqGH0AX9kpGzXax71j7/
mrl+PZsocDJxCxP8ndFRRIeTub58GWosXDhYDp9W+UjAh3pnDbt+UBSkro+10DPg
WHTG46NMNxHR9J35ne2mQZpRPSmEzGkt06TFHFfcHnfq/O4A6Ys=
=Y0NV
-----END PGP SIGNATURE-----

--IJpNTDwzlM2Ie8A6--
