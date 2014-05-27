Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:38384 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbaE0QMD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 12:12:03 -0400
Received: by mail-wi0-f171.google.com with SMTP id cc10so2083810wib.10
        for <linux-wireless@vger.kernel.org>; Tue, 27 May 2014 09:12:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1401206274.8146.8.camel@jlt4.sipsolutions.net>
References: <1401107504-11385-1-git-send-email-chaitanya.mgit@gmail.com> <1401206274.8146.8.camel@jlt4.sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Tue, 27 May 2014 21:41:40 +0530
Message-ID: <CABPxzYK+fhSdEwka9cU3O+VEsJpABViCg9OgdEJ=3t27OLyYTw@mail.gmail.com> (sfid-20140527_181235_438611_5A27529A)
Subject: Re: [PATCH V2] regdb: Generalize the mW to dBm power conversion
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	Luis Rodriguez <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 27, 2014 at 9:27 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
> On Mon, 2014-05-26 at 18:01 +0530, chaitanya.mgit@gmail.com wrote:
> > Generalize the power conversion from mW to dBm
> > using log. This should fix the below compilation
> > error for country NO which adds a new power value
> > 2000mW which is not handled earlier.
> >
> >  CC [M]  net/wireless/wext-sme.o
> >  CC [M]  net/wireless/regdb.o
> > net/wireless/regdb.c:1130:1: error: Unknown undeclared here (not in
> > a function)
> > net/wireless/regdb.c:1130:9: error: expected } before power
> > make[2]: *** [net/wireless/regdb.o] Error 1
> > make[1]: *** [net/wireless] Error 2
> > make: *** [net] Error 2
> >
> > Reported-By:  John Walker <john@x109.net>
> > Signed-off-by: Chaitanya T K <chaitanya.mgit@gmail.com>
> >
> > ---
> >  net/wireless/genregdb.awk |   12 +-----------
> >  1 file changed, 1 insertion(+), 11 deletions(-)
> >
> > diff --git a/net/wireless/genregdb.awk b/net/wireless/genregdb.awk
> > index 4119833..949ee38 100644
> > --- a/net/wireless/genregdb.awk
> > +++ b/net/wireless/genregdb.awk
> > @@ -68,17 +68,7 @@ function parse_reg_rule()
> >       sub(/,/, "", units)
> >       dfs_cac = $9
> >       if (units == "mW") {
> > -             if (power == 100) {
> > -                     power = 20
> > -             } else if (power == 200) {
> > -                     power = 23
> > -             } else if (power == 500) {
> > -                     power = 27
> > -             } else if (power == 1000) {
> > -                     power = 30
> > -             } else {
> > -                     print "Unknown power value in database!"
> > -             }
> > +             power = 10 * (log(power)/log(10))
>
> This patch is wrong :-)
> Bonus points for those who can figure it out without looking at the one
> I'm committing ;-)
>
Forgot to handle the print to the file. (Looked at the commit :-))
Thanks Johannes and John.
