Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48126 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbaAQSy7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jan 2014 13:54:59 -0500
Message-ID: <1389984896.10404.6.camel@jlt4.sipsolutions.net> (sfid-20140117_195502_927861_F923142F)
Subject: Re: [PATCH] cfg80211: Do not call CRDA when using internal
 regulatory database
From: Johannes Berg <johannes@sipsolutions.net>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 17 Jan 2014 19:54:56 +0100
In-Reply-To: <CABPxzYKwscRHAEEKs-y377Fa4rRLQBOp=5iUnVhYn+wjeTeG0A@mail.gmail.com> (sfid-20140117_195223_539769_0B118ABB)
References: <1389909758-6807-1-git-send-email-chaitanya.mgit@gmail.com>
	 <CABPxzYKwscRHAEEKs-y377Fa4rRLQBOp=5iUnVhYn+wjeTeG0A@mail.gmail.com>
	 (sfid-20140117_195223_539769_0B118ABB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2014-01-18 at 00:22 +0530, Krishna Chaitanya wrote:
> On Fri, Jan 17, 2014 at 3:32 AM, Chaitanya T K <chaitanya.mgit@gmail.com> wrote:
> >
> > When using internal regulatory data base kconfig option
> > do not try to call crda, this complely defeats the
> > purposes of enabling internal regulatory db.
> >
> > Signed-off-by: Chaitanya T K <chaitanya.mgit@gmail.com>
> >
> > ---
> >  net/wireless/reg.c |   29 +++++++++++++++--------------
> >  1 file changed, 15 insertions(+), 14 deletions(-)
> >
> > diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> > index 7d20d84..1cb0f99 100644
> > --- a/net/wireless/reg.c
> > +++ b/net/wireless/reg.c
> > @@ -454,16 +454,16 @@ static void reg_regdb_search(struct work_struct *work)
> >
> >  static DECLARE_WORK(reg_regdb_work, reg_regdb_search);
> >
> > -static void reg_regdb_query(const char *alpha2)
> > +static int reg_regdb_query(const char *alpha2)
> >  {
> >         struct reg_regdb_search_request *request;
> >
> >         if (!alpha2)
> > -               return;
> > +               return -1;
> >
> >         request = kzalloc(sizeof(struct reg_regdb_search_request), GFP_KERNEL);
> >         if (!request)
> > -               return;
> > +               return -1;
> >
> I guess the return values must be 1 so that in case of failure
> we ignore the reg update. Will wait for sometime for other
> comments and send V2.

-1 is -EPERM anyway, which doesn't seem appropriate.

johannes


