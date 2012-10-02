Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45771 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877Ab2JBNNh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Oct 2012 09:13:37 -0400
Received: by pbbrr4 with SMTP id rr4so8756626pbb.19
        for <linux-wireless@vger.kernel.org>; Tue, 02 Oct 2012 06:13:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1349174009-16496-1-git-send-email-sven@narfation.org>
References: <1348756862-8788-1-git-send-email-sven@narfation.org>
	<1349174009-16496-1-git-send-email-sven@narfation.org>
Date: Tue, 2 Oct 2012 06:13:37 -0700
Message-ID: <CAJ-VmontNVV4TyRO5kEM30T=OmfEN8YUciJSW=j_0HnbadF4JA@mail.gmail.com> (sfid-20121002_151347_497193_B1C4EC5F)
Subject: Re: [PATCHv2] ath9k_hw: Handle AR_INTR_SYNC_HOST1_FATAL on AR9003
From: Adrian Chadd <adrian@freebsd.org>
To: Sven Eckelmann <sven@narfation.org>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	linville@tuxdriver.com, mcgrof@qca.qualcomm.com,
	lindner_marek@yahoo.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

.. well, the rule here is "You shouldn't get PERR/FATAL interrupts."

Haven't I posted a summary of what those errors are?

Ok. So they're signals from the PCIe core (named host1_fatal and
host1_perr. Helpfully.) Those errors occured during a DMA transfer.

So the question is why you're seeing PERR interrupts when creating an
adhoc interface. That hints to me that something odd is going on..

I've seen these issues creep up when the NIC is in some way behaving
very, very badly (lots of timeouts and sync errors with little to no
traffic at all), which resulted in all kinds of odd and weird,
unstable behaviour. After replacing the NIC with another NIC (in my
case, an AR9280 -> AR9280 NIC :-) the errors went away and things
continued swimmingly.

I'd have to go digging through the PCIe core source to figure out
exactly what host1_peer and host1_fatal mean. I can if you'd like,
it'll just take some time as I'm not familiar at all with the PCIe
host interface.

Thanks,



Adrian

On 2 October 2012 03:33, Sven Eckelmann <sven@narfation.org> wrote:
> Interrupts with the sync_cause AR_INTR_SYNC_HOST1_FATAL has to be handled
> using a chip reset. Otherwise a interrupt storm with unhandled interrupts
> will cause a hang or crash of the machine.
>
> Signed-off-by: Sven Eckelmann <sven@narfation.org>
> ---
> I was informed that AR_INTR_SYNC_HOST1_PERR should not be handled this way
> because it can create system freezes after an adhoc interface was created.
>
> I really need some Atheros developer who can check the documentation to
> verify the interpretation of these flags. Otherwise this is just guessing
> and may lead to even bigger problems.
>
>  drivers/net/wireless/ath/ath9k/ar9003_mac.c |    5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
> index d5b2e0e..6031bdf 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
> +++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
> @@ -311,6 +311,11 @@ static bool ar9003_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
>         if (sync_cause) {
>                 ath9k_debug_sync_cause(common, sync_cause);
>
> +               if (sync_cause & AR_INTR_SYNC_HOST1_FATAL) {
> +                       ath_dbg(common, ANY, "received PCI FATAL interrupt\n");
> +                       *masked |= ATH9K_INT_FATAL;
> +               }
> +
>                 if (sync_cause & AR_INTR_SYNC_RADM_CPL_TIMEOUT) {
>                         REG_WRITE(ah, AR_RC, AR_RC_HOSTIF);
>                         REG_WRITE(ah, AR_RC, 0);
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
