Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from webmail.newmedia-net.de ([185.84.6.166]:54871 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727135AbeGaJYX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jul 2018 05:24:23 -0400
Subject: Re: ath9k and 16 VAP interfaces?
To: Tom Psyborg <pozega.tomislav@gmail.com>,
        Ben Greear <greearb@candelatech.com>
Cc: Matthias May <matthias.may@neratec.com>, michael-dev@fami-braun.de,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <8ecda6f3-68ab-5752-c8de-4086d21ba309@candelatech.com>
 <EB834EF3-21B2-4E6F-BEA8-1411407310F0@fami-braun.de>
 <0896f150-13f8-daae-c956-f60a2f7feeaf@neratec.com>
 <b3a42b0c-4e8a-b1fe-56eb-74eb7e71deaf@candelatech.com>
 <CAKR_QVKz5dZeL6dfstmXA7eghKc=1PNPvKQH7Qvha9H0OehEJQ@mail.gmail.com>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <43c86d63-714b-8712-ca87-d249211666c3@dd-wrt.com> (sfid-20180731_094605_315118_7A30F84D)
Date: Tue, 31 Jul 2018 09:45:19 +0200
MIME-Version: 1.0
In-Reply-To: <CAKR_QVKz5dZeL6dfstmXA7eghKc=1PNPvKQH7Qvha9H0OehEJQ@mail.gmail.com>
Content-Type: multipart/alternative;
 boundary="------------C56AC7D9B822261093AFCE16"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------C56AC7D9B822261093AFCE16
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

for standard ath9k. (non htc) the following is just enough

Index: init.c
===================================================================
--- init.c      (revision 4145)
+++ init.c      (working copy)
@@ -735,7 +735,7 @@

  static const struct ieee80211_iface_limit if_limits[] = {
         { .max = 2048,  .types = BIT(NL80211_IFTYPE_STATION) },
-       { .max = 8,     .types =
+       { .max = 16,    .types =
  #ifdef CPTCFG_MAC80211_MESH
                                  BIT(NL80211_IFTYPE_MESH_POINT) |
  #endif



but for sure i havent tested it


Am 30.07.2018 um 22:04 schrieb Tom Psyborg:
> this is how i enabled it on htc target: 
> https://github.com/torvalds/linux/pull/574
>
> On 30 July 2018 at 16:34, Ben Greear <greearb@candelatech.com 
> <mailto:greearb@candelatech.com>> wrote:
>
>
>
>     On 07/30/2018 04:13 AM, Matthias May wrote:
>
>         On 30/07/18 11:40, michael-dev@fami-braun.de
>         <mailto:michael-dev@fami-braun.de> wrote:
>
>             Do you mean AP interfaces as required for multiple BSS/SSIDs?
>
>             I'm running a patched ath9k to have hostapd run >8 BSS on
>             a single radio.
>             It works fine since years.
>
>
>     Yes, I'd love to see any patches you can share on this as well.
>
>     Thanks,
>     Ben
>
>
>
>             Regards,
>             M. Braun
>
>
>             Am 27. Juli 2018 15:35:28 MESZ schrieb Ben Greear
>             <greearb@candelatech.com <mailto:greearb@candelatech.com>>:
>
>                 Hello,
>
>                 Has anyone tried making ath9k able to support 16 vAP
>                 interfaces on a
>                 single
>                 radio?  I seem to recall that there were limitations
>                 regarding beacon
>                 timers and such, and that is why the current limit is 8?
>
>                 Thanks,
>                 Ben
>
>                 --
>                 Ben Greear <greearb@candelatech.com
>                 <mailto:greearb@candelatech.com>>
>                 Candela Technologies Inc http://www.candelatech.com
>
>
>
>         Are these patches available somewhere?
>         I'm interested to play with them :)
>
>         BR
>         Matthias
>
>
>     -- 
>     Ben Greear <greearb@candelatech.com <mailto:greearb@candelatech.com>>
>     Candela Technologies Inc http://www.candelatech.com
>
>


--------------C56AC7D9B822261093AFCE16
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: 8bit

<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  </head>
  <body text="#000000" bgcolor="#FFFFFF">
    <p>for standard ath9k. (non htc) the following is just enough</p>
    <p>Index: init.c<br>
===================================================================<br>
      --- init.c      (revision 4145)<br>
      +++ init.c      (working copy)<br>
      @@ -735,7 +735,7 @@<br>
      <br>
       static const struct ieee80211_iface_limit if_limits[] = {<br>
              { .max = 2048,  .types = BIT(NL80211_IFTYPE_STATION) },<br>
      -       { .max = 8,     .types =<br>
      +       { .max = 16,    .types =<br>
       #ifdef CPTCFG_MAC80211_MESH<br>
                                       BIT(NL80211_IFTYPE_MESH_POINT) |<br>
       #endif<br>
    </p>
    <p><br>
    </p>
    <p><br>
    </p>
    <p>but for sure i havent tested it <br>
    </p>
    <br>
    <div class="moz-cite-prefix">Am 30.07.2018 um 22:04 schrieb Tom
      Psyborg:<br>
    </div>
    <blockquote type="cite"
cite="mid:CAKR_QVKz5dZeL6dfstmXA7eghKc=1PNPvKQH7Qvha9H0OehEJQ@mail.gmail.com">
      <meta http-equiv="content-type" content="text/html; charset=utf-8">
      <div dir="ltr">this is how i enabled it on htc target: <a
          href="https://github.com/torvalds/linux/pull/574"
          moz-do-not-send="true">https://github.com/torvalds/linux/pull/574</a><span
          class="sewuaq5cj8zgk32"></span><span class="sewiybm83cm6k9e"></span><br>
      </div>
      <div class="gmail_extra"><br>
        <div class="gmail_quote">On 30 July 2018 at 16:34, Ben Greear <span
            dir="ltr">&lt;<a href="mailto:greearb@candelatech.com"
              target="_blank" moz-do-not-send="true">greearb@candelatech.com</a>&gt;</span>
          wrote:<br>
          <blockquote class="gmail_quote" style="margin:0 0 0
            .8ex;border-left:1px #ccc solid;padding-left:1ex"><span
              class=""><br>
              <br>
              On 07/30/2018 04:13 AM, Matthias May wrote:<br>
              <blockquote class="gmail_quote" style="margin:0 0 0
                .8ex;border-left:1px #ccc solid;padding-left:1ex">
                On 30/07/18 11:40, <a
                  href="mailto:michael-dev@fami-braun.de"
                  target="_blank" moz-do-not-send="true">michael-dev@fami-braun.de</a>
                wrote:<br>
                <blockquote class="gmail_quote" style="margin:0 0 0
                  .8ex;border-left:1px #ccc solid;padding-left:1ex">
                  Do you mean AP interfaces as required for multiple
                  BSS/SSIDs?<br>
                  <br>
                  I'm running a patched ath9k to have hostapd run &gt;8
                  BSS on a single radio.<br>
                  It works fine since years.<br>
                </blockquote>
              </blockquote>
              <br>
            </span>
            Yes, I'd love to see any patches you can share on this as
            well.<br>
            <br>
            Thanks,<br>
            Ben
            <div class="HOEnZb">
              <div class="h5"><br>
                <br>
                <blockquote class="gmail_quote" style="margin:0 0 0
                  .8ex;border-left:1px #ccc solid;padding-left:1ex">
                  <blockquote class="gmail_quote" style="margin:0 0 0
                    .8ex;border-left:1px #ccc solid;padding-left:1ex">
                    <br>
                    Regards,<br>
                    M. Braun<br>
                    <br>
                    <br>
                    Am 27. Juli 2018 15:35:28 MESZ schrieb Ben Greear
                    &lt;<a href="mailto:greearb@candelatech.com"
                      target="_blank" moz-do-not-send="true">greearb@candelatech.com</a>&gt;:<br>
                    <blockquote class="gmail_quote" style="margin:0 0 0
                      .8ex;border-left:1px #ccc solid;padding-left:1ex">
                      Hello,<br>
                      <br>
                      Has anyone tried making ath9k able to support 16
                      vAP interfaces on a<br>
                      single<br>
                      radio?  I seem to recall that there were
                      limitations regarding beacon<br>
                      timers and such, and that is why the current limit
                      is 8?<br>
                      <br>
                      Thanks,<br>
                      Ben<br>
                      <br>
                      --<br>
                      Ben Greear &lt;<a
                        href="mailto:greearb@candelatech.com"
                        target="_blank" moz-do-not-send="true">greearb@candelatech.com</a>&gt;<br>
                      Candela Technologies Inc  <a
                        href="http://www.candelatech.com"
                        rel="noreferrer" target="_blank"
                        moz-do-not-send="true">http://www.candelatech.com</a><br>
                    </blockquote>
                    <br>
                  </blockquote>
                  <br>
                  Are these patches available somewhere?<br>
                  I'm interested to play with them :)<br>
                  <br>
                  BR<br>
                  Matthias<br>
                  <br>
                </blockquote>
                <br>
                -- <br>
                Ben Greear &lt;<a href="mailto:greearb@candelatech.com"
                  target="_blank" moz-do-not-send="true">greearb@candelatech.com</a>&gt;<br>
                Candela Technologies Inc  <a
                  href="http://www.candelatech.com" rel="noreferrer"
                  target="_blank" moz-do-not-send="true">http://www.candelatech.com</a><br>
              </div>
            </div>
          </blockquote>
        </div>
        <br>
      </div>
    </blockquote>
    <br>
  </body>
</html>

--------------C56AC7D9B822261093AFCE16--
