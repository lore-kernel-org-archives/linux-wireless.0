Return-Path: <SRS0=Jk3u=RW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81AD9C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 15:07:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5320520828
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 15:07:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="GXy35Fsn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbfCSPHu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Mar 2019 11:07:50 -0400
Received: from mout.gmx.net ([212.227.17.22]:55245 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726612AbfCSPHu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Mar 2019 11:07:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1553008052;
        bh=WPNsrlOZZ5wLYW+kGWxTIa/C9X5tDiZ5MDkLl1VUj9c=;
        h=X-UI-Sender-Class:Subject:From:In-Reply-To:Date:Cc:References:To;
        b=GXy35FsnIc68w/PnK6DODwIizmeg1F+0s4t5VuAqkDZOfKMAeRpO4lXc6svBKVLsu
         9MPPCQjCQwN48i3k91pZUq5wxvUm/cPU0g1ny3Ka+rz0FdaAquUz9Cnz5ZH8ixnfsn
         4fZ/l75Wo7A/FaznZwkhm2KddwcpwiRuF+iWuo1Q=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.4.14] ([79.201.202.244]) by mail.gmx.com (mrgmx101
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0MbKXI-1hP1fz3dBM-00IknC; Tue, 19
 Mar 2019 16:07:32 +0100
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH RFC v2] mac80211: debugfs option to force TX status frames
From:   Julius Niedworok <julius.n@gmx.net>
In-Reply-To: <20190311145240.akms2pz2hxsalmaz@azazel.net>
Date:   Tue, 19 Mar 2019 16:07:32 +0100
Cc:     Kalle Valo <kvalo@codeaurora.org>, ga58taw@mytum.de,
        linux-wireless@vger.kernel.org, david@redhat.com, nc@net.in.tum.de,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <D78A58DC-E38B-4BD8-9D11-A873FFE16602@gmx.net>
References: <e20962001ee10a0f90f8e2f1f8baafcf3b70e9dd.camel@sipsolutions.net>
 <20190306200206.60916-1-julius.n@gmx.net> <87k1hazo6r.fsf@purkki.adurom.net>
 <20190307193045.a7awwn6mycloccq5@mission-control>
 <87h8c98q4l.fsf@codeaurora.org> <20190311145240.akms2pz2hxsalmaz@azazel.net>
To:     Jeremy Sowden <jeremy@azazel.net>
X-Mailer: Apple Mail (2.3273)
X-Provags-ID: V03:K1:ElvT8yCZ9rlyh4ZjBcTI13LvQl+o+kw7y1Ic/JtWIzVw0Jde37I
 h1iAvsYTqqqmHGBwTcQkhV/OHXAdEgxJWc4iAr7efhvAbavuRMe23/8okEk+22ZHokLXKSP
 AA4QnXiOKXt1IbLhSz/90z9u+ay3fVZW43YRDnPAR/juZl6SAbw4dDVWyntdorGQsubc5XZ
 8uW6plTCqpE2jvNqvZv4A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:V6p1NcLpVoI=:m8WAF2ZRDn3/iMPyVlUfCe
 IEeajjeoLaehw4Y/WHVpMTKzokmfjdEncrzTMoD3i/mBopeLtZ2g7eTV93XMhZ5Y9zwrvcKCz
 aTET43nMtN7631d9EP6WFV+B2NaxXF3eBQyRun7ghVtwceYivnwKIKnig6f/VtFp+yJwDbDQr
 pP69ya/euCqnJIg33FNjVIKRtn4E9Dm7z5gTTAh03nH7iI2dO+i2uAnIw8RQNvecoUHt9a8OC
 eeprvztfiu43UlJA+5dg7u5Z9iNvlg0FCCHcSiSAdL2zhvFiKPvwD3RV+6VBBHiVLmx/iugIS
 mvo6YfcxyT69cIZvsnU2FXVvIJUbpiDWuvmTQFJ/Lc/Pi9xV3qpkB5NaNPksoMVZcPJdS8z+8
 Ey0U1c4ZKNzNRC59GFGZ9EBzTJI5ZC2BRDk2PgIDx21gAKT5NHRKPkjn84sNxdVAaGDKK+ip5
 yDij9UzFwnOPhFFfzq8g6bLkVVcAr5hdPam7FORSr9B2Q0LYs1IZBmEV56stvaSpBIHxLdas5
 Ec8WCyVw2okjj9gYILlcqRu4iy3qKffAdtvcf/h9sEKX0kq9Ekf3dogVP5VAc2cvyC4PUNfbH
 A1qbGTNU0JHESrHq/A6HWi3DALb9rjQ2as0K4AsqV5AJxyK7PQbycHcsJo+1nozgUMwhkJKdx
 vzuJb+I+k6WZlWUggBfJ9oobsV/wGGMtONz5ggFIuqEmiCnagpRrLboUOUkKeDBmhpMj59qZ3
 58wgavZQgSMFqZlX0WqF1beOk97m+kVlHZUBrJ38SMk0Rbpht6+1Ue4uPQDgn+PZB1F8DlKjh
 hpXO8ZxBRLYLjAegGUmkGI1hLe9gMt2UIPWoNIJsj6rlwbgqNBZzrvs5s840Kxbzp1DpAhXYB
 BQkx0c0bmKLD9SmGp5TxHiqdGrGEVTxcyhamd+Cyp0kyyyb6m9N9i4N35SaGJzQ1bylnVsn/b
 5X+J4fTZAog==
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


> On 11.03.2019 15:52, Jeremy Sowden wrote:
>
> It's the value that matters, not the type.  It will only be too big for
> the buffer if the result of casting local->force_tx_status to int is
> less than -9 or greeater than 99.
>
>  scnprintf(buf, size(buf), "%lld\n", (long long)local->force_tx_status)
>
> would also be fine if the value were in range.  Note also that scnprintf
> will not overrun the buffer: it will truncate the string.

Thanks for the clarification :)

> As it happens, arguments to variadic functions are subject to the
> "default argument promotions," so if local->force_tx_status is in fact a
> bool (I can't find the definition), it would be promoted to int and the
> cast is superfluous.

Yes - the cast is superfluous. We still think it might be useful to keep i=
t
there to make the point that the value will be casted. However, if you
prefer to omit the cast, we are happy to take it out.


Thank you,
Julius and Charlie
