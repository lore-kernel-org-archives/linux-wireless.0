Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:35797 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845Ab1G2GqR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jul 2011 02:46:17 -0400
Date: Fri, 29 Jul 2011 12:16:29 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/9] ath9k: Dump base eeprom header for AR9003
Message-ID: <20110729064628.GA2268@vmraj-lnx.users.atheros.com> (sfid-20110729_084623_355334_50F71495)
References: <1311874176-27569-1-git-send-email-rmanohar@qca.qualcomm.com>
 <CAB=NE6WfMgGQCzWUtdnA70w-u9agG8SS-W=JKL1V0nL8Rq=TEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <CAB=NE6WfMgGQCzWUtdnA70w-u9agG8SS-W=JKL1V0nL8Rq=TEA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 28, 2011 at 02:11:32PM -0700, Luis R. Rodriguez wrote:
> On Thu, Jul 28, 2011 at 10:29 AM, Rajkumar Manoharan
> <rmanohar@qca.qualcomm.com> wrote:
> > Debugfs file location:
> > <debugfs_mnt>/ieee80211/phy#/ath9k/base_eeprom
> >
> > Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> > ---
> >  drivers/net/wireless/ath/ath9k/debug.c |  147 ++++++++++++++++++++++++++++++++
> >  1 files changed, 147 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
> > index d1eb896..df71c72 100644
> > --- a/drivers/net/wireless/ath/ath9k/debug.c
> > +++ b/drivers/net/wireless/ath/ath9k/debug.c
> > @@ -1163,6 +1163,151 @@ static const struct file_operations fops_regdump = {
> >        .llseek = default_llseek,/* read accesses f_pos */
> >  };
> >
> > +static ssize_t read_file_base_eeprom(struct file *file, char __user *user_buf,
> > +                                    size_t count, loff_t *ppos)
> > +{
> > +       struct ath_softc *sc = file->private_data;
> > +       struct ath_hw *ah = sc->sc_ah;
> > +       struct ar9300_base_eep_hdr *pBase = NULL;
> > +       unsigned int len = 0, size = 1500;
> > +       ssize_t retval = 0;
> > +       char *buf;
> > +
> > +       if (!AR_SREV_9300_20_OR_LATER(ah))
> > +               return 0;
> 
> This is really really cool stuff, but instead of doing this can we
> instead implement this as a callback design which would enable other
> hw revisions to be supported? If we do not then we need to make the
> code branch out on each type of card.
>
Yeah. Let us have common cb and ath9k & ath9k_htc can make use of it.
Thanks for your comments.

--
Rajkumar
