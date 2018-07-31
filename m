Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lj1-f194.google.com ([209.85.208.194]:38860 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729680AbeGaUPj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jul 2018 16:15:39 -0400
Received: by mail-lj1-f194.google.com with SMTP id p6-v6so14579030ljc.5
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2018 11:34:03 -0700 (PDT)
MIME-Version: 1.0
References: <1533039077-1532-1-git-send-email-vnaralas@codeaurora.org> <3dd6d368-e54e-d8ba-d538-c48617a575b9@candelatech.com>
In-Reply-To: <3dd6d368-e54e-d8ba-d538-c48617a575b9@candelatech.com>
From: Jasmine Strong <jas@eero.com>
Date: Tue, 31 Jul 2018 11:33:50 -0700
Message-ID: <CAGyitvPa_m-59jOQdRp55ku2LopqGSWucOYSFH-pT28pk3=kAA@mail.gmail.com> (sfid-20180731_203407_953592_3B1AB34B)
Subject: Re: [PATCHv2] ath10k : Fix channel survey dump
To: Ben Greear <greearb@candelatech.com>
Cc: vnaralas@codeaurora.org, ath10k <ath10k@lists.infradead.org>,
        linux-wireless@vger.kernel.org
Content-Type: multipart/alternative; boundary="00000000000076154705724fd208"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--00000000000076154705724fd208
Content-Type: text/plain; charset="UTF-8"

On Tue, Jul 31, 2018 at 10:38 AM Ben Greear <greearb@candelatech.com> wrote:

> On 07/31/2018 05:11 AM, Venkateswara Naralasetty wrote:
> > Channel active/busy time are showing incorrect(less than previous or
> > sometimes zero) for successive survey dump command.
> >
> > example:
> > Survey data from wlan0
> >       frequency:                      5180 MHz [in use]
> >       channel active time:            54995 ms
> >       channel busy time:              432 ms
> >       channel receive time:           0 ms
> >       channel transmit time:          59 ms
> > Survey data from wlan0
> >       frequency:                      5180 MHz [in use]
> >       channel active time:            32592 ms
> >       channel busy time:              254 ms
> >       channel receive time:           0 ms
> >       channel transmit time:          0 ms
> >
> > This patch fix this issue by assigning 'wmi_bss_survey_req_type'
> > as 'WMI_BSS_SURVEY_REQ_TYPE_READ' which accumulate survey data in
> > FW and send survey data to driver upon the driver request. Wrap around
> > is taken care by FW.
> >
> > hardware used : QCA9984
> > firmware ver  : ver 10.4-3.5.3-00057
>
> Have you tested this on other firmwares?  I am pretty sure that at least
> some of them, probably 10.2, will have issues.
>
> Maybe you could make this change specific to certain firmware that
> is known to work with the change?
>
>
There are bigger problems with it than that;  even with firmwares that
behave correctly,
this changes the behavior that a lot of upper-layer software depends upon,
and will likely
make anything that actually uses the channel survey data misbehave.

It is therefore a breaking change for any device that actually implements
ACS.

-J.

--00000000000076154705724fd208
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><br><div class=3D"gmail_quote"><div dir=3D"ltr">On Tue=
, Jul 31, 2018 at 10:38 AM Ben Greear &lt;<a href=3D"mailto:greearb@candela=
tech.com">greearb@candelatech.com</a>&gt; wrote:<br></div><blockquote class=
=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padd=
ing-left:1ex">On 07/31/2018 05:11 AM, Venkateswara Naralasetty wrote:<br>
&gt; Channel active/busy time are showing incorrect(less than previous or<b=
r>
&gt; sometimes zero) for successive survey dump command.<br>
&gt;<br>
&gt; example:<br>
&gt; Survey data from wlan0<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0frequency:=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 5180 MHz [in use]<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0channel active time:=C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 54995 ms<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0channel busy time:=C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 432 ms<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0channel receive time:=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A00 ms<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0channel transmit time:=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 59 ms<br>
&gt; Survey data from wlan0<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0frequency:=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 5180 MHz [in use]<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0channel active time:=C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 32592 ms<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0channel busy time:=C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 254 ms<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0channel receive time:=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A00 ms<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0channel transmit time:=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 0 ms<br>
&gt;<br>
&gt; This patch fix this issue by assigning &#39;wmi_bss_survey_req_type&#3=
9;<br>
&gt; as &#39;WMI_BSS_SURVEY_REQ_TYPE_READ&#39; which accumulate survey data=
 in<br>
&gt; FW and send survey data to driver upon the driver request. Wrap around=
<br>
&gt; is taken care by FW.<br>
&gt;<br>
&gt; hardware used : QCA9984<br>
&gt; firmware ver=C2=A0 : ver 10.4-3.5.3-00057<br>
<br>
Have you tested this on other firmwares?=C2=A0 I am pretty sure that at lea=
st<br>
some of them, probably 10.2, will have issues.<br>
<br>
Maybe you could make this change specific to certain firmware that<br>
is known to work with the change?<br><br></blockquote><div><br></div><div>T=
here are bigger problems with it than that;=C2=A0 even with firmwares that =
behave correctly,</div><div>this changes the behavior that a lot of upper-l=
ayer software depends upon, and will likely</div><div>make anything that ac=
tually uses the channel survey data misbehave.</div><div><br></div><div>It =
is therefore a breaking change for any device that actually implements ACS.=
</div><div><br></div><div>-J.=C2=A0</div></div></div>

--00000000000076154705724fd208--
