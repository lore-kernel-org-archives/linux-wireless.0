Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:36621 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752682AbXLLAH2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2007 19:07:28 -0500
Subject: Re: [WIP][PATCH] rc80211_pid: Send events to userspace for
	debugging
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1197414686.7030.27.camel@localhost>
References: <1197414686.7030.27.camel@localhost>
Content-Type: multipart/mixed; boundary="=-7pbxgvEhEjeTBzY/NKln"
Date: Wed, 12 Dec 2007 01:07:24 +0100
Message-Id: <1197418044.7030.32.camel@localhost> (sfid-20071212_000732_183515_27BFF5CB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7pbxgvEhEjeTBzY/NKln
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi,

Ok, I just decided I make the script generate a second graph. Updated
script is attached, new sample graph is at
http://www-user.rhrk.uni-kl.de/~nissler/rate_control_sample_graph2.ps

I guess from the second graph we can see that the integration interval
is too large. I think I should try increasing the proportional
coefficient and decrease the integral coefficient. What do you think?
Control theory people please speak up :-)

Mattias

--=-7pbxgvEhEjeTBzY/NKln
Content-Disposition: attachment; filename=make_pid_graph.py
Content-Type: text/x-python; name=make_pid_graph.py; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

#!/usr/bin/python
#
# Feed an rc80211_pid events file into gnuplot to create a nice graph.
#

import os
import sys
import subprocess
import optparse

# configurable options
options = optparse.Values()

options.arith_scale_factor = float(256)
options.graph_width = None
options.graph_height = 10 
options.units_per_jiffy = 0.0002
options.xtics = 10000
options.events_file_name = None
options.output_file_name = '-'
options.gnuplot_path = '/usr/bin/gnuplot'

def plot_frames_rate_graph(gpo, events):

	# configure the axes
	gpo.write('set xlabel "Time [jiffies]"\n')
	gpo.write('set xrange [0:%f]\n' % events[-1][1])
	gpo.write('set xtics %d\n' % options.xtics)
	gpo.write('set ylabel "Failed frames [%]"\n')
	gpo.write('set yrange [0:50]\n')
	gpo.write('set ytics 5 nomirror\n')
	gpo.write('set y2label "TX rate [Mbit/s]\n')
	gpo.write('set y2range [0:60]\n')
	gpo.write('set y2tics 5 nomirror\n')

	gpo.write('plot "-" axes x1y1 title "failed frames percentage" with linespoints,')
	gpo.write('"-" axes x1y2 title "TX rate" with linespoints\n')

	for e in filter(lambda x: x[2] == 'pf_sample', events):
		gpo.write('%f %f\n' % (float(e[1]), float(e[3]) / options.arith_scale_factor))

	gpo.write('e\n');
	
	for e in filter(lambda x: x[2] == 'tx_rate', events):
		gpo.write('%f %f\n' % (float(e[1]), float(e[4]) / 10.0))

	gpo.write('e\n');

def plot_frames_error_graph(gpo, events):

	# configure the axes
	gpo.write('set xlabel "Time [jiffies]"\n')
	gpo.write('set xrange [0:%f]\n' % events[-1][1])
	gpo.write('set xtics %d\n' % options.xtics)
	gpo.write('set xzeroaxis\n')
	gpo.write('set ylabel "Failed frames [%]"\n')
	gpo.write('set yrange [-50:50]\n')
	gpo.write('set ytics 5 nomirror\n')
	gpo.write('set y2label "Error [%]\n')
	gpo.write('set y2range [-50:50]\n')
	gpo.write('set y2tics 5 nomirror\n')

	gpo.write('plot "-" axes x1y1 title "failed frames percentage" with linespoints,')
	gpo.write('"-" axes x1y2 title "proportional error" with linespoints,')
	gpo.write('"-" axes x1y2 title "integral error" with linespoints,')
	gpo.write('"-" axes x1y2 title "derivation error" with linespoints\n')

	for e in filter(lambda x: x[2] == 'pf_sample', events):
		gpo.write('%f %f\n' % (float(e[1]), float(e[3]) / options.arith_scale_factor))

	gpo.write('e\n');
	
	for e in filter(lambda x: x[2] == 'pf_sample', events):
		gpo.write('%f %f\n' % (float(e[1]), float(e[4]) / options.arith_scale_factor))

	gpo.write('e\n');
	
	for e in filter(lambda x: x[2] == 'pf_sample', events):
		gpo.write('%f %f\n' % (float(e[1]), float(e[5]) / options.arith_scale_factor))

	gpo.write('e\n');
	
	for e in filter(lambda x: x[2] == 'pf_sample', events):
		gpo.write('%f %f\n' % (float(e[1]), float(e[6]) / options.arith_scale_factor))

	gpo.write('e\n');

def parse_options():
	parser = optparse.OptionParser()

	parser.add_option('-i', '--infile', dest='events_file_name',
		help='rc80211_pid event dump file')
	parser.add_option('-o', '--outfile', dest='output_file_name',
		help='Output file to which graph is written')
	parser.add_option('-y', '--height', type='int', dest='graph_height',
		help='Width of the diagram')
	parser.add_option('-x', '--width', type='int', dest='graph_width',
		help='Height of the diagram')

	parser.parse_args(sys.argv[1:], options)

	parser.destroy()

def main():
	# Parse options
	parse_options();

	# read the input
	if options.events_file_name is None:
		eventsfile = sys.stdin
	else:
		eventsfile = open(options.events_file_name, 'r')

	events = map(lambda x: x.split(), eventsfile.readlines())
	eventsfile.close()

	if len(events) == 0:
		raise 'No input!'

	# calculate time interval
	time_start = int(events[0][1])
	time_end = int(events[-1][1])
	time_diff = time_end - time_start

	# normalize time
	for e in events:
		e[1] = int(e[1]) - time_start

	# open a pipe to gnuplot
	gpp = subprocess.Popen(options.gnuplot_path, stdin=subprocess.PIPE)
	gpo = gpp.stdin

	# configure the gnuplot output
	if options.graph_width is None:
		options.graph_width = time_diff * options.units_per_jiffy

	nplots = 2

	gpo.write('set terminal postscript color lw 0.1 size %fcm, %fcm font "Helvetica" 9\n' %
		(options.graph_width, options.graph_height * nplots))
	gpo.write('set output "%s"\n' % options.output_file_name)

	# plot the graphs
	gpo.write('set multiplot layout %d,1 columnsfirst downwards\n' % nplots)

	plot_frames_rate_graph(gpo, events);

	plot_frames_error_graph(gpo, events);
	
	gpo.write('unset multiplot\n')

	# done!
	gpo.close()

if __name__ == '__main__':
	main()


--=-7pbxgvEhEjeTBzY/NKln--

