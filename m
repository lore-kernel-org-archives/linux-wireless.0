Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from as-smtp4.itc.alstom.com ([159.245.16.39]:25918 "EHLO
	as-smtp4.itc.alstom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbaAWQam convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 11:30:42 -0500
From: LANGLOIS Olivier PIS -EXT
	<olivier.pis.langlois@transport.alstom.com>
To: Takashi Iwai <tiwai@suse.de>,
	Olivier Langlois <olivier@trillion01.com>
CC: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"James Cameron" <quozl@laptop.org>,
	"daniel@zonque.org" <daniel@zonque.org>
Subject: RE: [alsa-devel] [ISSUE] rtl8192ce appears to interfere with	ALSA
	playback
Date: Thu, 23 Jan 2014 16:15:19 +0000
Message-ID: <89F8E4011FD7234ABFE48744E300CBC206BCE732@041-DB3MPN1-092.041d.mgd.msft.net> (sfid-20140123_173045_527913_752EECE0)
References: <1389767820.2436.45.camel@Wailaba2>
 <52D6BEEF.5050705@lwfinger.net> <52D76D56.6060906@trillion01.com>
 <20140116055547.GU19393@us.netrek.org> <1390464800.2436.111.camel@Wailaba2>
 <s5htxcvt718.wl%tiwai@suse.de>
In-Reply-To: <s5htxcvt718.wl%tiwai@suse.de>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Takashi,

> > 2. I was expecting to see XRUN entries in dmesg but I didn't. The
> > closest that I have is [ 1700.756017] PCM: Lost interrupts? [Q]
> > (stream=0, delta=16108, new_hw_ptr=383756, old_hw_ptr=367648) 3. I
> > didn't realise that the default ALSA device was a plugin using dmix. I
> > have no underruns by using directly the ALSA HW device (hw:0,0)
>
> The dmix uses the fixed configuration.  Did you try playback using hw but
> with the same configuration (period size, buffer size, format)?
>
this is a very good observation.

With the same buffer/period sizes at a sampling rate of 44100 (this slightly modify the buffer/period times), I have 0 underruns. As soon as I resample my wav file to 48kHz, boom the underruns happens.

So if I understand correctly by reducing the buffer time correctly from 371504 usec to 341328 usec and by assuming that the buffer is full, if the snd_hda_intel irq/timer are delayed to a greater amount of time than 341328 usec, this is what is causing the underruns.

Maybe it is important to the discussion that my CONFIG_HZ=1000 and

$ zgrep PREEMPT /proc/config.gz
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
# CONFIG_DEBUG_PREEMPT is not set
# CONFIG_PREEMPT_TRACER is not set

$ aplay -Dhw:0,0 --period-size=1024 --buffer-size=16384 -v sine.wav
Playing WAVE 'sine.wav' : Signed 16 bit Little Endian, Rate 44100 Hz, Stereo
Hardware PCM card 0 'HDA Intel' device 0 subdevice 0
Its setup is:
  stream       : PLAYBACK
  access       : RW_INTERLEAVED
  format       : S16_LE
  subformat    : STD
  channels     : 2
  rate         : 44100
  exact rate   : 44100 (44100/1)
  msbits       : 16
  buffer_size  : 16384
  period_size  : 1024
  period_time  : 23219
  tstamp_mode  : NONE
  period_step  : 1
  avail_min    : 1024
  period_event : 0
  start_threshold  : 16384
  stop_threshold   : 16384
  silence_threshold: 0
  silence_size : 0
  boundary     : 1073741824
  appl_ptr     : 0
  hw_ptr       : 0

$ aplay -Dhw:0,0 --period-size=1024 --buffer-size=16384 -v sine_48000.wav
Playing WAVE 'sine_48000.wav' : Signed 16 bit Little Endian, Rate 48000 Hz, Stereo
Hardware PCM card 0 'HDA Intel' device 0 subdevice 0
Its setup is:
  stream       : PLAYBACK
  access       : RW_INTERLEAVED
  format       : S16_LE
  subformat    : STD
  channels     : 2
  rate         : 48000
  exact rate   : 48000 (48000/1)
  msbits       : 16
  buffer_size  : 16384
  period_size  : 1024
  period_time  : 21333
  tstamp_mode  : NONE
  period_step  : 1
  avail_min    : 1024
  period_event : 0
  start_threshold  : 16384
  stop_threshold   : 16384
  silence_threshold: 0
  silence_size : 0
  boundary     : 1073741824
  appl_ptr     : 0
  hw_ptr       : 0
underrun!!! (at least 0.075 ms long)
Status:
  state       : XRUN
  trigger_time: 2155.298508067
  tstamp      : 2155.299242462
  delay       : 0
  avail       : 16815
  avail_max   : 16815


________________________________
CONFIDENTIALITY : This e-mail and any attachments are confidential and may be privileged. If you are not a named recipient, please notify the sender immediately and do not disclose the contents to another person, use it for any purpose or store or copy the information in any medium.
