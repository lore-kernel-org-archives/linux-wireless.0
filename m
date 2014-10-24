Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59785 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755925AbaJXIe4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2014 04:34:56 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
	by mailout.nyi.internal (Postfix) with ESMTP id 50E1420C60
	for <linux-wireless@vger.kernel.org>; Fri, 24 Oct 2014 04:34:55 -0400 (EDT)
Message-Id: <1414139694.796795.182782121.5786657C@webmail.messagingengine.com> (sfid-20141024_103513_778929_ABABA22D)
From: =?UTF-8?Q?Lauren=C8=9Biu=20Nicola?= <lnicola@dend.ro>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: poma <pomidorabelisima@gmail.com>, Dan Williams <dcbw@redhat.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
In-Reply-To: <CANUX_P1MAY1gGjsGsk7P-Z4GBAAO_vdikbniphf7rk1jxy9Mbw@mail.gmail.com>
References: <1413463736.1316541.179720977.4FD32021@webmail.messagingengine.com>
 <54463CE9.3060400@gmail.com>
 <1413921415.3763081.181696749.20A0A495@webmail.messagingengine.com>
 <CANUX_P0LRRczVCSFR7RE5coaYFxwFXyqC90pdm=oVwEiEt-7zw@mail.gmail.com>
 <1414014805.4127522.182191541.14C8B4DF@webmail.messagingengine.com>
 <CANUX_P0tGagXsN6XCeb_itQehqD3O9fmqknU6iSMO432NQtATA@mail.gmail.com>
 <1414049448.32460.182326557.1A0A85A4@webmail.messagingengine.com>
 <CANUX_P3usjdccnsYPQXzKbJ1PTH91fasf6BpcsCRYZH_yq2tww@mail.gmail.com>
 <1414080125.164673.182502929.61AF3AB1@webmail.messagingengine.com>
 <CANUX_P2pJYNhLEMw=iQVe-CSbxqRDqOXL_gUZXxwpmAj2qj=FA@mail.gmail.com>
 <1414085934.228950.182543717.6FA0F16D@webmail.messagingengine.com>
 <CANUX_P0nK9AQEzYGfGFKEU_vVJ9fwOPmjGTCL--zmk+J4uCz4Q@mail.gmail.com>
 <1414093367.254547.182592325.0C3991E4@webmail.messagingengine.com>
 <CANUX_P3sTY45ozSL6Rj0PRYgo9aPACdp97HV1SQna3AW5V75xw@mail.gmail.com>
 <1414094840.260168.182602541.16435971@webmail.messagingengine.com>
 <5449621C.3070400@gmail.com>
 <1414096032.264032.182610177.3DACE1A9@webmail.messagingengine.com>
 <CANUX_P0FPDSjAzh1uJ2LxWp9H8CXJgK1sdE+HYMcrTVLNH+1Kg@mail.gmail.com>
 <CANUX_P1MAY1gGjsGsk7P-Z4GBAAO_vdikbniphf7rk1jxy9Mbw@mail.gmail.com>
Subject: Re: iwlwifi: Reason 7 periodic disconnect
Date: Fri, 24 Oct 2014 11:34:54 +0300
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Okay, I've filed a bug [1].

At some point you mentioned about using another device to monitor
traffic. I don't have another laptop running Linux (would Android
count?), but DD-WRT has a "wl monitor" command [2] that sounds useful.
Should I try to install tcpdump on my router?

Laurentiu

[1] https://bugzilla.kernel.org/show_bug.cgi?id=86801
[2] http://www.dd-wrt.com/wiki/index.php/Wl#monitor

On Fri, Oct 24, 2014, at 08:32, Emmanuel Grumbach wrote:
> On Thu, Oct 23, 2014 at 11:33 PM, Emmanuel Grumbach <egrumbach@gmail.com>
> wrote:
> > On Thu, Oct 23, 2014 at 11:27 PM, Laurențiu Nicola <lnicola@dend.ro> wrote:
> >> https://bpaste.net/show/8a0e5c68762f
> >>
> >> On Thu, Oct 23, 2014, at 23:16, Emmanuel Grumbach wrote:
> >>> > https://bpaste.net/show/5cc48256d952
> >>> >
> >>> > On Thu, Oct 23, 2014, at 22:55, Emmanuel Grumbach wrote:
> >>> >> On Thu, Oct 23, 2014 at 10:42 PM, Laurențiu Nicola <lnicola@dend.ro>
> >>> >> wrote:
> >>> >>> Doesn't seem to help https://bpaste.net/show/68e1a6b33689.
> >>> >>
> >>> >> ok - let me re-add the logs...
> >>> >>
> >>> >>
> >>>
> >>> This makes no sense to me.
> >>> We do talk to the AP since we get frames Acked...
> >
> > This again makes no sense to me.
> > Time to go to bed I guess.
> 
> Can you please open a bug on bugzilla.kernel.org?
> Make sure to CC ilw@linux.intel.com
> 
> This will make it more trackable.
> Thanks.
> 
> >
> >>>
> >>> Can you please apply this on top of what you have?
> >>>
> >>> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> >>> index 2de8870..f3b1e62 100644
> >>> --- a/net/mac80211/mlme.c
> >>> +++ b/net/mac80211/mlme.c
> >>> @@ -1991,15 +1991,16 @@ void ieee80211_sta_tx_notify(struct
> >>> ieee80211_sub_if_data *sdata,
> >>>         if (ieee80211_is_nullfunc(hdr->frame_control) &&
> >>>             sdata->u.mgd.probe_send_count > 0) {
> >>>                 if (ack)
> >>> -                       ieee80211_sta_reset_conn_monitor(sdata);
> >>> +               //      ieee80211_sta_reset_conn_monitor(sdata);
> >>> +               ;
> >>>                 else
> >>>                         sdata->u.mgd.nullfunc_failed = true;
> >>>                 ieee80211_queue_work(&sdata->local->hw, &sdata->work);
> >>>                 return;
> >>>         }
> >>>
> >>> -       if (ack)
> >>> -               ieee80211_sta_reset_conn_monitor(sdata);
> >>> +//     if (ack)
> >>> +//             ieee80211_sta_reset_conn_monitor(sdata);
> >>>  }
> >>>
> >>>  static void ieee80211_mgd_probe_ap_send(struct ieee80211_sub_if_data
> >>>  *sdata)
> >>>
> >>>
> >>> Thanks.
> >>> --
> >>> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
> >>> in
> >>> the body of a message to majordomo@vger.kernel.org
> >>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
