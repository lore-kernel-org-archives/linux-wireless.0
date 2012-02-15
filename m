Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:29634 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753650Ab2BOTKj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Feb 2012 14:10:39 -0500
Date: Wed, 15 Feb 2012 20:10:32 +0100
From: Jakub Kicinski <kubakici@wp.pl>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH v2 1/4] rt2800pci: remove
 rt2800pci_set_state function
Message-ID: <20120215201032.51647fee@north> (sfid-20120215_201045_873618_01F47955)
In-Reply-To: <CAL1gcdMb3+iiUU1rDLoEO1tWNE92_v4tC5X+hDa3PGzY-mXW-g@mail.gmail.com>
References: <1329108519-5342-1-git-send-email-kubakici@wp.pl>
	<1329108519-5342-2-git-send-email-kubakici@wp.pl>
	<CAL1gcdPWEf_qYcjp8nYuZNkJUR=pA93P3-hi5xhokvUm1t-Ljg@mail.gmail.com>
	<20120214180551.70389f5e@north>
	<CAL1gcdMb3+iiUU1rDLoEO1tWNE92_v4tC5X+hDa3PGzY-mXW-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 15 Feb 2012 16:42:49 +0100 Gertjan van Wingerde <gwingerde@gmail.com> wrote:
> On Tue, Feb 14, 2012 at 6:05 PM, Jakub Kicinski <kubakici@wp.pl> wrote:
> > On Tue, 14 Feb 2012 11:47:37 +0100 Gertjan van Wingerde <gwingerde@gmail.com> wrote:
> >> On Mon, Feb 13, 2012 at 5:48 AM, Jakub Kicinski <kubakici@wp.pl> wrote:
> >> > rt2800pci_set_state was introduced to group requests preceded with
> >> > common introduction. As that introduction is no longer used
> >> > rt2800pci_set_state can be removed.
> >> >
> >> > Note that this patch changes behaviour for STATE_DEEP_SLEEP and
> >> > STATE_STANDBY, but those states are not used in rt2800 anyway.
> >> >
> >> > Signed-off-by: Jakub Kicinski <kubakici@wp.pl>
> >>
> >> I know this patch has been out there for a while, but I only now have
> >> taken a good look at it.
> >> First of all, I think that it would have been easy to not change the
> >> behaviour for STATE_DEEP_SLEEP
> >> and STATE_STANDBY, even though these are not used in rt2800. They can
> >> simply be put as their
> >> own cases in the switch statement in which nothing is done.
> >
> > True, I have decided to make the change because:
> >  1) I couldn't find any reason to treat those states differently than
> >    normal SLEEP;
> >  2) rt61pci and rt2500pci treats them equally;
> >  3) the differentiation was introduced by Jay in 7f6e144f and the change
> >    looks like it may have not been 100% intentional. At least my newbie
> >    mind is telling me that. No one asked about it at the time and commit
> >    message also doesn't explain this change.
> >
> > Please let me know if this reasoning makes any sense to you.
> 
> OK. Looking at this closer it actually looks like that these two
> states are not used at
> all in rt2x00. So, I guess I can be fine with this.
> 
> >
> >> Also some comments to the actual code below.
> >>
> >> > ---
> >> >  drivers/net/wireless/rt2x00/rt2800pci.c |   38 ++++++++++--------------------
> >> >  1 files changed, 13 insertions(+), 25 deletions(-)
> >> >
> >> > diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
> >> > index 6ad6929..6ab4637 100644
> >> > --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> >> > +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> >> > @@ -517,23 +517,6 @@ static void rt2800pci_disable_radio(struct rt2x00_dev *rt2x00dev)
> >> >        }
> >> >  }
> >> >
> >> > -static int rt2800pci_set_state(struct rt2x00_dev *rt2x00dev,
> >> > -                              enum dev_state state)
> >> > -{
> >> > -       if (state == STATE_AWAKE) {
> >> > -               rt2800_mcu_request(rt2x00dev, MCU_WAKEUP, TOKEN_WAKUP, 0, 0x02);
> >> > -               rt2800pci_mcu_status(rt2x00dev, TOKEN_WAKUP);
> >> > -       } else if (state == STATE_SLEEP) {
> >> > -               rt2x00pci_register_write(rt2x00dev, H2M_MAILBOX_STATUS,
> >> > -                                        0xffffffff);
> >> > -               rt2x00pci_register_write(rt2x00dev, H2M_MAILBOX_CID,
> >> > -                                        0xffffffff);
> >> > -               rt2800_mcu_request(rt2x00dev, MCU_SLEEP, 0x01, 0xff, 0x01);
> >> > -       }
> >> > -
> >> > -       return 0;
> >> > -}
> >> > -
> >> >  static int rt2800pci_set_device_state(struct rt2x00_dev *rt2x00dev,
> >> >                                      enum dev_state state)
> >> >  {
> >> > @@ -546,7 +529,7 @@ static int rt2800pci_set_device_state(struct rt2x00_dev *rt2x00dev,
> >> >                 * to be woken up. After that it needs a bit of time
> >> >                 * to be fully awake and then the radio can be enabled.
> >> >                 */
> >> > -               rt2800pci_set_state(rt2x00dev, STATE_AWAKE);
> >> > +               rt2800pci_set_device_state(rt2x00dev, STATE_AWAKE);
> >> >                msleep(1);
> >> >                retval = rt2800pci_enable_radio(rt2x00dev);
> >> >                break;
> >>
> >> I don't like this recursive call, but this is removed in patch 4, so I
> >> don't mind it here.
> >>
> >> > @@ -556,17 +539,22 @@ static int rt2800pci_set_device_state(struct rt2x00_dev *rt2x00dev,
> >> >                 * be put to sleep for powersaving.
> >> >                 */
> >> >                rt2800pci_disable_radio(rt2x00dev);
> >> > -               rt2800pci_set_state(rt2x00dev, STATE_SLEEP);
> >> > -               break;
> >> > -       case STATE_RADIO_IRQ_ON:
> >> > -       case STATE_RADIO_IRQ_OFF:
> >> > -               rt2800pci_toggle_irq(rt2x00dev, state);
> >> > -               break;
> >> > +               /* fall through */
> >>
> >> I don't really like this falling through, which is just there out of
> >> convenience, as the states have
> >> some common code. However, in reality these states have not a lot in
> >> common, so just a bit
> >> of code duplication would have been better here, IMHO.
> >
> > Ok, I will change that and perhaps put that "duplicated" code into
> > rt2800pci_disable_radio to keep switch statement short.
> >
> 
> Fine with me. Maybe the same could be done with respect to the new code
> and rt2800pci_enable_radio.

Well, that would be nice. Maybe the right way is to move all the
additional code from the switch to appropriate functions and create a
function for SLEEP as well (so it could be called from disable_radio
without recursion), leaving nice and concise switch without duplicated
code. However, that would probably had to be done in rt2800usb as well
causing even more code-moving and patches (move something out of switch
and remove an unneeded function aren't the same thing, right?) and the
purpose of this patch was originally to get rid of a simple error! ;-)

  -- Kuba
