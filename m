Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:49790 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbeIGXFJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Sep 2018 19:05:09 -0400
Received: from mail-yw1-f71.google.com ([209.85.161.71])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <seth.forshee@canonical.com>)
        id 1fyLPH-0001P2-BG
        for linux-wireless@vger.kernel.org; Fri, 07 Sep 2018 18:22:59 +0000
Received: by mail-yw1-f71.google.com with SMTP id i63-v6so9365640ywb.3
        for <linux-wireless@vger.kernel.org>; Fri, 07 Sep 2018 11:22:59 -0700 (PDT)
Date: Fri, 7 Sep 2018 13:22:56 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Henrik Laxhuber <henrik@laxhuber.com>
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org
Subject: Re: [PATCH] wireless-regdb: update regulatory rules for Switzerland
 (CH), and Liechtenstein (LI) on 5GHz
Message-ID: <20180907182256.GL4251@ubuntu-xps13> (sfid-20180907_202303_308982_AFA204C2)
References: <2441d0ea-b862-9675-9342-356606d9228d@laxhuber.com>
 <20180907123256.GJ4251@ubuntu-xps13>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20180907123256.GJ4251@ubuntu-xps13>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 07, 2018 at 07:32:56AM -0500, Seth Forshee wrote:
> On Thu, Sep 06, 2018 at 04:13:22PM +0200, Henrik Laxhuber wrote:
> > Update to reflect the current data published in the 'National Frequency
> > Allocation Strategy Table' [0] for Switzerland and Liechtenstein, which
> > at the time of writing points to the documents [1] and [2].
> > 
> > [0] https://www.ofcomnet.ch/#/fatTable
> > [1] https://www.ofcomnet.ch/api/rir/1010/05
> > [2] https://www.ofcomnet.ch/api/rir/1010/04
> > 
> > Signed-off-by: Henrik Laxhuber <henrik@laxhuber.com>
> > ---
> >  db.txt | 19 +++++++++++++++----
> >  1 file changed, 15 insertions(+), 4 deletions(-)
> > 
> > diff --git a/db.txt b/db.txt
> > index 8cf7dee..69cea85 100644
> > --- a/db.txt
> > +++ b/db.txt
> > @@ -265,10 +265,14 @@ country CF: DFS-FCC
> >      (5490 - 5730 @ 40), (24), DFS
> >      (5735 - 5835 @ 40), (30)
> > 
> > +# Source:
> > +# https://www.ofcomnet.ch/#/fatTable
> > +# Note that the maximum transmitter power can be doubled for 5250-5710MHz
> > if
> > +# transmitter power control is in use: 5250-5330@23db, 5490-5710@30db
> >  country CH: DFS-ETSI
> >      (2402 - 2482 @ 40), (20)
> > -    (5170 - 5250 @ 80), (20), AUTO-BW, wmmrule=ETSI
> > -    (5250 - 5330 @ 80), (20), DFS, AUTO-BW, wmmrule=ETSI
> > +    (5170 - 5250 @ 80), (23), NO-OUTDOOR, AUTO-BW, wmmrule=ETSI
> 
> Maybe you missed this in my last reply, I had suggested this range can
> be 5150-5250 as in the document you linked to. If you agree with this
> change I can make it when I apply the patch.

Applied with this change here and in the rules for Liechtenstein.
Thanks!
