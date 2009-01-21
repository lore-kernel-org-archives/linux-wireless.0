Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f20.google.com ([209.85.219.20]:38652 "EHLO
	mail-ew0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbZAUQ5U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jan 2009 11:57:20 -0500
Received: by ewy13 with SMTP id 13so1610065ewy.13
        for <linux-wireless@vger.kernel.org>; Wed, 21 Jan 2009 08:57:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090121154120.GC3459@sortiz.org>
References: <1232516035-25524-4-git-send-email-reinette.chatre@intel.com>
	 <1232516035-25524-5-git-send-email-reinette.chatre@intel.com>
	 <200901210801.23236.helmut.schaa@gmail.com>
	 <2d0a357f0901210532v3ac57896ia3a75c9911267edb@mail.gmail.com>
	 <20090121154120.GC3459@sortiz.org>
Date: Wed, 21 Jan 2009 17:57:16 +0100
Message-ID: <2d0a357f0901210857p2c3503fdwa2be5d87ee4b15e8@mail.gmail.com> (sfid-20090121_175729_250118_457F7DE9)
Subject: Re: [ipw3945-devel] [PATCH 4/5] iwl3945: Use iwl-rfkill
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Samuel Ortiz <samuel.ortiz@intel.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: multipart/mixed; boundary=0015174c34a25d8cd60461010ce7
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--0015174c34a25d8cd60461010ce7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Samuel,

my original email was bounced by the linux-wireless-mailing-mailserver
complaining email was not in plain-text & "suspicious" file
attachment, tststs.

On Wed, Jan 21, 2009 at 4:41 PM, Samuel Ortiz <samuel.ortiz@intel.com> wrote:
> Hi Sedat,
>
> On Wed, Jan 21, 2009 at 06:32:05AM -0700, Sedat Dilek wrote:
>> Hi,
>>
>> I applied Helmut's complain towards rfkill-changes into a patch (see below).
>> Together with the latest iwlwifi-driver-updates (01_19_2009 + 01_20_2009) I played around with the WLAN-LED-button of my notebook.
>>
>> Turning the LED off, I got the following error-message:
>> [...]
>> Jan 21 14:13:32 seduxbox kernel: iwl3945 0000:10:00.0: Error sending REPLY_LEDS_CMD: enqueue_hcmd failed: -5
>> [...]
> A couple questions:
> - Are you running the latest wireless-testing ?
> - Can you reproduce this error (I can't) ?
>

I am running wl.git (master-2009-01-19) plus latest two
iwlwifi-updates (19-Jan-2009/20-Jan-2009) patchseries, enriched with
the "overseen rfkill-patch" complained by Helmut and finally
2.6.29-rc2-git1 patch.
Well I tested once (1st testing), and after my first euphoric gladness
I had two or three reconnects to my WLAN-AP - I noticed some dis- and
reconnections in my IRC-client.

Right now (2nd testing), I loaded the iwl3945-kernel-module with debug-options:

$ modprobe iwl3945 debug=0x43fff

Report is added. Euphoria is gone :-).

>> What does error-code "-5" mean?
> That's -EIO, see iwl_enqueue_hcmd() in iwl-tx.c.
>

drivers/net/wireless/iwlwifi/iwl-tx.c says:
[...]
iwl_enqueue_hcmd - enqueue a uCode command
[...]
The function returns < 0 values to indicate the operation is failed.
[...]

So is this a ucode-problem?


Kind regards,
Sedat

> Cheers,
> Samuel.
>
>
>> Is this maybe a 2.6.29 kernel issue?
>>
>> Turning LED on, the wlan-connection is established automatically and Internet connection works fine again.
>>
>> Full report is attached.
>>
>> Kind Regards,
>> Sedat
>>
>> ----- SNIP -----
>>
>> Index: linux-2.6/drivers/net/wireless/iwlwifi/iwl-core.c
>> ===================================================================
>> --- linux-2.6.orig/drivers/net/wireless/iwlwifi/iwl-core.c.orig
>> +++ linux-2.6/drivers/net/wireless/iwlwifi/iwl-core.c
>> @@ -1481,7 +1481,8 @@
>>          IWL_DEBUG(IWL_DL_RF_KILL,
>>                "HW and/or SW RF Kill no longer active, restarting "
>>                "device\n");
>> -        if (!test_bit(STATUS_EXIT_PENDING, &priv->status))
>> +        if (!test_bit(STATUS_EXIT_PENDING, &priv->status) &&
>> +            test_bit(STATUS_ALIVE, &priv->status))
>>              queue_work(priv->workqueue, &priv->restart);
>>      } else {
>>          /* make sure mac80211 stop sending Tx frame */
>>
>> ----- SNAP -----
>>
>> On Wed, Jan 21, 2009 at 8:01 AM, Helmut Schaa <helmut.schaa@googlemail.com<mailto:helmut.schaa@googlemail.com>> wrote:
>> Hi,
>>
>> Am Mittwoch, 21. Januar 2009 schrieb Reinette Chatre:
>> > From: Samuel Ortiz <samuel.ortiz@intel.com<mailto:samuel.ortiz@intel.com>>
>> >
>> > Here again, the rfkill routines are duplicated between agn and 3945. Let's
>> > move the agn one to iwlcore, and so we can get rid of the 3945 ones.
>>
>> [...]
>>
>> > +void iwl_bg_rf_kill(struct work_struct *work)
>> > +{
>> > +     struct iwl_priv *priv = container_of(work, struct iwl_priv, rf_kill);
>> > +
>> > +     wake_up_interruptible(&priv->wait_command_queue);
>> > +
>> > +     if (test_bit(STATUS_EXIT_PENDING, &priv->status))
>> > +             return;
>> > +
>> > +     mutex_lock(&priv->mutex);
>> > +
>> > +     if (!iwl_is_rfkill(priv)) {
>> > +             IWL_DEBUG(IWL_DL_RF_KILL,
>> > +                       "HW and/or SW RF Kill no longer active, restarting "
>> > +                       "device\n");
>> > +             if (!test_bit(STATUS_EXIT_PENDING, &priv->status))
>> > +                     queue_work(priv->workqueue, &priv->restart);
>>
>> I've changed this check in both rf-kill patches (3945 and agn) to
>>
>> if (!test_bit(STATUS_EXIT_PENDING, &priv->status) &&
>>    test_bit(STATUS_ALIVE, &priv->status))
>>
>> in order to avoid restarting the adapter when notified about rfkill changes
>> by interrupt/polling.
>>
>> I guess this is just an oversight, right?
>>
>> Thanks,
>> Helmut
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org<mailto:majordomo@vger.kernel.org>
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> Content-Description: report_iwlwifi_rfkill_2.6.29-rc2-git1-iniza-4.txt
>> ----- BEGIN LED OFF -----
>>
>> Jan 21 14:13:27 seduxbox kernel: iwl3945 0000:10:00.0: Radio Frequency Kill Switch is On:
>> Jan 21 14:13:27 seduxbox kernel: Kill switch must be turned off for wireless networking to work.
>> Jan 21 14:13:28 seduxbox kernel: usb 1-2: USB disconnect, address 2
>> Jan 21 14:13:28 seduxbox kernel: sierra ttyUSB0: Sierra USB modem converter now disconnected from ttyUSB0
>> Jan 21 14:13:28 seduxbox kernel: sierra ttyUSB1: Sierra USB modem converter now disconnected from ttyUSB1
>> Jan 21 14:13:28 seduxbox kernel: sierra ttyUSB2: Sierra USB modem converter now disconnected from ttyUSB2
>> Jan 21 14:13:28 seduxbox kernel: sierra 1-2:1.0: device disconnected
>> Jan 21 14:13:32 seduxbox kernel: wlan0: No ProbeResp from current AP 00:04:0e:e4:00:3d - assume out of range
>> Jan 21 14:13:32 seduxbox kernel: iwl3945 0000:10:00.0: Error sending REPLY_LEDS_CMD: enqueue_hcmd failed: -5
>>
>> ----- END LED OFF -----
>>
>>
>> ----- BEGIN LED ON -----
>>
>> Jan 21 14:14:47 seduxbox kernel: Registered led device: iwl-phy0:radio
>> Jan 21 14:14:47 seduxbox kernel: Registered led device: iwl-phy0:assoc
>> Jan 21 14:14:47 seduxbox kernel: Registered led device: iwl-phy0:RX
>> Jan 21 14:14:47 seduxbox kernel: Registered led device: iwl-phy0:TX
>> Jan 21 14:14:50 seduxbox kernel: usb 1-2: new full speed USB device using uhci_hcd and address 3
>> Jan 21 14:14:50 seduxbox kernel: usb 1-2: New USB device found, idVendor=03f0, idProduct=1e1d
>> Jan 21 14:14:50 seduxbox kernel: usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
>> Jan 21 14:14:50 seduxbox kernel: usb 1-2: Product: HP hs2300 HSDPA Broadband Wireless Module
>> Jan 21 14:14:50 seduxbox kernel: usb 1-2: Manufacturer: HP
>> Jan 21 14:14:50 seduxbox kernel: usb 1-2: configuration #1 chosen from 1 choice
>> Jan 21 14:14:50 seduxbox kernel: sierra 1-2:1.0: Sierra USB modem converter detected
>> Jan 21 14:14:50 seduxbox kernel: usb 1-2: Sierra USB modem converter now attached to ttyUSB0
>> Jan 21 14:14:50 seduxbox kernel: usb 1-2: Sierra USB modem converter now attached to ttyUSB1
>> Jan 21 14:14:50 seduxbox kernel: usb 1-2: Sierra USB modem converter now attached to ttyUSB2
>> Jan 21 14:15:18 seduxbox kernel: wlan0: authenticate with AP 00:04:0e:e4:00:3d
>> Jan 21 14:15:18 seduxbox kernel: wlan0: authenticate with AP 00:04:0e:e4:00:3d
>> Jan 21 14:15:18 seduxbox kernel: wlan0: authenticated
>> Jan 21 14:15:18 seduxbox kernel: wlan0: associate with AP 00:04:0e:e4:00:3d
>> Jan 21 14:15:18 seduxbox kernel: wlan0: RX ReassocResp from 00:04:0e:e4:00:3d (capab=0x411 status=0 aid=1)
>> Jan 21 14:15:18 seduxbox kernel: wlan0: associated
>>
>> ----- END LED ON -----
>>
>
>
> --
> Intel Open Source Technology Centre
> http://oss.intel.com/
> ---------------------------------------------------------------------
> Intel Corporation SAS (French simplified joint stock company)
> Registered headquarters: "Les Montalets"- 2, rue de Paris,
> 92196 Meudon Cedex, France
> Registration Number:  302 456 199 R.C.S. NANTERRE
> Capital: 4,572,000 Euros
>
> This e-mail and any attachments may contain confidential material for
> the sole use of the intended recipient(s). Any review or distribution
> by others is strictly prohibited. If you are not the intended
> recipient, please contact the sender and delete all copies.
>
>

--0015174c34a25d8cd60461010ce7
Content-Type: application/x-gzip; name="syslog.log_iwl3945.gz"
Content-Disposition: attachment; filename="syslog.log_iwl3945.gz"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fq88gab20

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
xP5szjObP5v4TOyvsjjPXP46xGdafx3OM5s/m/hM7M/kS8WYL2bPTD+oMiblCVVOUzaoMiblCVXG
RJ2gypiUJ1QZEXWEKmNSnlBlTFS6QJUxKU+oMibqBFXGpDyhypioE1QZkyosqDKbPxuvTOzPhiqz
+JMiVmcVx1WgiaCUDbmMSXkilzFRkz69TvLHpGyoMps/G69M7M9kjuN5/mkWBCvca0Y4G4BgjIk6
EYwhKV+CMSbqRDDGpDwJxpioE8EYk/IkGGOiTgRjTMqTYIyJOhGMMSlPgjEm6kQwhqQ6BGMufx2W
MbE/m2DM5s9mGRP7swnGLv7yUCzj/f7yUARjNn82y5jYn8kX1xW/ORsuGJLyxQVjok64YEzKExeM
iTrhgjEpT1wwJuqEC8akPHHBmKgTLhiT8sQFY6JOuGBIqoMLZvEnM6EmgrI40ERQzgYTxqQ8YcKY
qBNMGJPyhAmnBRNMGBHyggkjguZLKLGvB1wwk68HcDCprwdcMJOvB3Awqa8HXDCTrwdwMKmvB1ww
ky/zBaCiDg4LF8xlzQIH03qzcMFc3ixwMK03CxfM5c0CB9N6s3DBXN4scDCtNwsX7OKtDAMO3u+t
DIML5vKWPICDab1ZuGAubxY4mNbb9m2cz5sLmxcS8mPzQpIubF5IyI/Ni0huJ/aps8STzQtJurB5
ISE/Ni8k6cLmhYT82Lz+komiLSSBaAuQc4vcS1vFFq+Xq/tY5F5Sbzav18VbFYbcu99bFYbXy+XN
IvfSemvzxfUjQsXE5oWE/Ni8kGSbJf0+H1Rh6Ldc3iwOLqk3m37L5M3m4NJ6s+i3XN4sDi6tN4t+
y+XN4uDSessf6Ldc3iwOLq03i37r4C2Lw3Bw93pDhGz6LZM3m4NL682i33J5szi4tN4s+i2XN4uD
S+vNot9yebM4uLTeLPotlzeLg0vqzabfMnmzObi03iz6LZc3i4NL682i33J5szi4tN7yB/oti7ei
aPSKPMy0DeTchY0LCfmxcTPBxMaFhPzYuJCkCxsXEvJj40KSLmxcSMiPjQtJtknT64gPSMii33J5
szi4tN4s+i2TN5uDS+rNpt9yebM4uLTeLPotlzeLg0vrzaLfcnmzOLi03iz6LZc3i4NL682i37p4
k4E4uPvNyVD0WzZ7NgeX2J9Z4+Z4jgcm6kTuw6Q8yX2YaO5C7sOkPMl9mKgTuQ+T8iT3QaJu5D5M
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
jBCvo6P607zJvOZfo+ZfkUs2hZtffrEuuvmNkJc9ex9dLBbr1XrZ3KB3x7o5ryef6ujDD2EqoxG4
X87Xtbp1bq/qdf2quZWuriIRNb/ZPICbyl9hWXx3aydxI6Oi+O423DPlYTHR5hXu8N3bv56op0gs
QJFlfXv1ZdxkV/N4PNR/v5uqJlitm5GJ6pHx5i/xcDPEvwo1cRRQeJufujHacizrad38c/ZdgI42
v1mtx6vbyXJl/KnfafvZSuV2025VHHNJybyQAbQ217eePu3to0YDi1kjvNE+Oz18j6jpZ5FuqeYh
PlmuCdtr1QyStavx7Xq5ik7vbtbNYLP1ddsMcZo7dhVNmuFz8ye/C3eD7S6e+xe4weKAwqYe4ZZ6
UJjNV5OLq3pc/9IM1FfRWX21marbNNXV4lPU/pfryRc1x9r++VlAzSi6+KKjXcXt/xT/c9V09/XC
KEUX8/X15DaoXnNHqZspmqybBmp+Rk7LV5ubOi2iu0RCAzL7DgvWYL+XKOylVcZ5mQbL3W44hQ7d
Tm94oyZ528g4UPmA9OpnYCS+19mFkfxGy/NQ83e3s+aNsX0PUzPjb9SrVvTL5Oqu1q9GbWKXQUXO
f41Ub1LfDb6P4qCXPqW79NlVXd9G+rHc1E/zdjBdL9Tz9P82b+Kvdv7//zyVu99Bzna+gXz88LeT
0/H54dG7E/VRI/rmD0XxxyaU63+qGyVO1WlBSd48Kdb1Suf2KP77QRpq5KD3hT2zsminZGo0URQk
dbAZsxydj48//Pjm7Z+bOqguOnXQjGuEVQdiJALWQdrUQfJMHeyUTH9xvoCmfBrLzWh0+WszTjLV
cPrzhx/3X/NP0f18/Vn/4fGbt+/Om7bRX07G789+6PPT6otL80u1ZL/PH79YreYzdb+pT3H2/wh7
gPLWNL6IO43fjG3T8qHx5UgGbPyiafz0q42vCqUXN8ThhuvFzt6JJ2hVYRRyXOHRBwH1NdZ8FWh6
VZQdNGP/SwUIiWarW4WsjZYTPV3RDCuaFpwNoHk5gGY2gGYxgGY1gObFAJqCXjOqiq5mQqcp42Tj
U2RdzQm/pkj5NZOCXzOvCZ+W5z+PP/6tO3SsukPH5FWUWcOmZJQEfHKqVenFV5+cuwXUoyeoFSaz
mXql3MzazWZqYaD63iPTg+jy8qD7P8KaP3ytv4qqoUrZqfD0VZRbQ5V0lAascHvPYKcc+sleYtOW
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
+NV1BwA=
--0015174c34a25d8cd60461010ce7--
